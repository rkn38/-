import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

/// شاشة إنشاء مدير جديد
/// متاحة فقط للمدراء الحاليين
class CreateAdminScreen extends StatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  State<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAdmin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final loc = AppLocalizations.of(context);
      
      try {
        // إنشاء حساب مدير جديد
        final success = await authProvider.createAdminByAdmin(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
        
        if (!mounted) return;
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.tr('adminCreated')),
              backgroundColor: AppColors.successColor,
            ),
          );
          Navigator.pop(context, true); // إرجاع true للتحديث
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? loc.tr('error')),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.errorColor,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr('createAdmin')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // أيقونة
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    size: 60,
                    color: AppColors.primaryColor,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  loc.tr('createAdmin'),
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  loc.isArabic 
                      ? 'أدخل بيانات المدير الجديد' 
                      : 'Enter new admin details',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 32),
                
                // حقل الاسم
                CustomTextField(
                  label: loc.tr('displayName'),
                  hint: loc.isArabic ? 'اسم المدير' : 'Admin Name',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: (value) => Validators.validateRequired(
                    value, 
                    fieldName: loc.tr('displayName'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // حقل البريد
                CustomTextField(
                  label: loc.tr('email'),
                  hint: 'admin@email.com',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                
                const SizedBox(height: 16),
                
                // حقل كلمة المرور
                CustomTextField(
                  label: loc.tr('password'),
                  hint: '••••••••',
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
                
                // تأكيد كلمة المرور
                CustomTextField(
                  label: loc.tr('confirmPassword'),
                  hint: '••••••••',
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
                
                // ملاحظة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.warningColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          loc.isArabic
                              ? 'سيحصل المدير الجديد على جميع صلاحيات الإدارة'
                              : 'The new admin will have full admin permissions',
                          style: TextStyle(
                            color: AppColors.warningColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // زر الإنشاء
                CustomButton(
                  text: loc.tr('createAdmin'),
                  onPressed: _handleCreateAdmin,
                  isLoading: _isLoading,
                  icon: Icons.person_add,
                ),
                
                const SizedBox(height: 16),
                
                // زر الإلغاء
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(loc.tr('cancel')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
