import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fake_store/core/constants/app_colors.dart';
import 'package:fake_store/core/constants/app_strings.dart';
import 'package:fake_store/core/constants/app_text_styles.dart';
import 'package:fake_store/core/widgets/loading_widget.dart';
import 'package:fake_store/core/widgets/empty_state_widget.dart';
import 'package:fake_store/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:fake_store/features/authentication/presentation/bloc/auth_event.dart';
import 'package:fake_store/features/authentication/presentation/bloc/auth_state.dart';

/// Profile page displaying user information and logout option
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
            ),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        title: const Text(AppStrings.profile),
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.successLogout),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/auth/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const AppLoadingWidget();
            }

            if (state is Authenticated) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              user.username[0].toUpperCase(),
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.username,
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.textWhite,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textWhite.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Information Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Information', style: AppTextStyles.h6),
                          const SizedBox(height: 16),

                          // Username Card
                          _InfoCard(
                            icon: Icons.person_outline,
                            label: AppStrings.username,
                            value: user.username,
                          ),
                          const SizedBox(height: 12),

                          // Email Card
                          _InfoCard(
                            icon: Icons.email_outlined,
                            label: AppStrings.email,
                            value: user.email,
                          ),
                          const SizedBox(height: 12),

                          // Name Card (if available)
                          if (user.name != null)
                            _InfoCard(
                              icon: Icons.badge_outlined,
                              label: 'Full Name',
                              value: user.name!.fullName,
                            ),
                          if (user.name != null) const SizedBox(height: 12),

                          // Phone Card (if available)
                          if (user.phone != null)
                            _InfoCard(
                              icon: Icons.phone_outlined,
                              label: AppStrings.phone,
                              value: user.phone!,
                            ),
                          if (user.phone != null) const SizedBox(height: 24),

                          // Address Section (if available)
                          if (user.address != null) ...[
                            Text(AppStrings.address, style: AppTextStyles.h6),
                            const SizedBox(height: 16),
                            _InfoCard(
                              icon: Icons.location_city_outlined,
                              label: AppStrings.city,
                              value: user.address!.city,
                            ),
                            const SizedBox(height: 12),
                            _InfoCard(
                              icon: Icons.home_outlined,
                              label: AppStrings.street,
                              value:
                                  '${user.address!.street} ${user.address!.number}',
                            ),
                            const SizedBox(height: 12),
                            _InfoCard(
                              icon: Icons.markunread_mailbox_outlined,
                              label: AppStrings.zipcode,
                              value: user.address!.zipcode,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _handleLogout(context),
                              icon: const Icon(Icons.logout),
                              label: Text(
                                AppStrings.logout,
                                style: AppTextStyles.buttonLarge,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: AppColors.textWhite,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Fallback for other states
            return const EmptyStateWidget(
              title: 'No user information available',
              message: 'Please log in to view your profile',
              icon: Icons.person_off_outlined,
            );
          },
        ),
      ),
    );
  }
}

/// Reusable info card widget for displaying user information
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelSmall),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
