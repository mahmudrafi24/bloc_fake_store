import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create AuthBloc instance
    final authBloc = di.sl<AuthBloc>();

    // Check authentication status on app start
    authBloc.add(const CheckAuthStatus());

    return MultiBlocProvider(
      providers: [
        // Global BLoCs
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<CartBloc>(
          create: (_) => di.sl<CartBloc>()..add(const LoadCart()),
        ),
      ],
      child: MaterialApp.router(
        title: 'FakeStore',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.createRouter(authBloc),
      ),
    );
  }
}
