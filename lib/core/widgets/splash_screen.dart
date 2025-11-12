import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart';
import '../../core/constants/app_colors.dart';

/// Splash screen that checks authentication status on app start
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Check authentication status and navigate accordingly
  void _checkAuthStatus() {
    // Listen to auth state changes
    final authBloc = context.read<AuthBloc>();

    // Wait for the first state emission after checking auth
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final authState = authBloc.state;

      if (authState is Authenticated) {
        // User is authenticated, navigate to products page
        context.go('/');
      } else if (authState is Unauthenticated || authState is AuthError) {
        // User is not authenticated, navigate to login page
        context.go('/auth/login');
      }
      // If still loading, the BlocListener will handle navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/');
        } else if (state is Unauthenticated || state is AuthError) {
          context.go('/auth/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Icon(Icons.shopping_bag, size: 100, color: AppColors.textWhite),
              const SizedBox(height: 24),
              // App Name
              Text(
                'FakeStore',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
