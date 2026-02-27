import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (success && mounted) {
      context.go('/profile-setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Header
              FadeInDown(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonBlue.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Welcome Back', style: AppTextStyles.heading1),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue your fitness journey',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Form
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: AppStrings.email,
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: Validators.validatePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: AppStrings.password,
                          prefixIcon: const Icon(Icons.lock_outlined,
                              color: AppColors.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.forgotPassword,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.neonBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Login button
                      GradientButton(
                        text: AppStrings.login,
                        onPressed: _handleLogin,
                        isLoading: authState.isLoading,
                      ),
                      // Error
                      if (authState.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          authState.error!,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.error),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Divider
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: AppColors.glassBorder),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.orContinueWith,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: AppColors.glassBorder),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Google Sign In
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: GlassmorphicCard(
                  onTap: () async {
                    final success =
                        await ref.read(authProvider.notifier).signInWithGoogle();
                    if (success && mounted) {
                      context.go('/profile-setup');
                    }
                  },
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.g_mobiledata_rounded,
                          size: 28, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.googleSignIn,
                        style: AppTextStyles.bodyBold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Sign up link
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.noAccount, style: AppTextStyles.body),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(
                        AppStrings.signUp,
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neonBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
