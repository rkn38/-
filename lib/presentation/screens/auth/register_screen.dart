import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loc = AppLocalizations.of(context);
      
      // التسجيل كمستخدم عادي فقط
      final success = await authProvider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
        role: 'user', // دائماً مستخدم عادي
      );
      
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${loc.tr('welcome')} ${authProvider.currentUser?.displayName}! ${loc.tr('registerSuccess')}'),
            backgroundColor: AppColors.successColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? loc.tr('loginFailed')),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr('register')),
        actions: [
          // زر تبديل اللغة
          TextButton.icon(
            onPressed: () => localeProvider.toggleLocale(),
            icon: const Icon(Icons.language),
            label: Text(localeProvider.isArabic ? 'EN' : 'ع'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                Text(
                  loc.tr('createAccount'),
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  loc.tr('fillDataToRegister'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 32),
                
                CustomTextField(
                  label: loc.tr('displayName'),
                  hint: localeProvider.isArabic ? 'أحمد محمد' : 'John Doe',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: (value) => Validators.validateRequired(
                    value, 
                    fieldName: loc.tr('displayName'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: loc.tr('email'),
                  hint: 'example@email.com',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: loc.tr('password'),
                  hint: '••••••',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: loc.tr('confirmPassword'),
                  hint: '••••••',
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  controller: _confirmPasswordController,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomButton(
                      text: loc.tr('register'),
                      onPressed: _handleRegister,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.tr('alreadyHaveAccount'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        loc.tr('login'),
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
