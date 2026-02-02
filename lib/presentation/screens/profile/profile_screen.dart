import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../../data/repositories/book_repository.dart';
import 'settings_screen.dart';
import '../library/favorites_screen.dart';
import '../../providers/font_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.get('profile'))),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (!authProvider.isAuthenticated) {
            return Center(child: Text(l10n.get('loginToSeeLibrary')));
          }

          final user = authProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? Text(
                          user.displayName.isNotEmpty
                              ? user.displayName[0]
                              : '?',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),

                const SizedBox(height: 8),

                // Email
                Text(user.email, style: Theme.of(context).textTheme.bodyMedium),

                const SizedBox(height: 8),

                // Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: user.isAdmin
                        ? AppColors.secondaryColor.withOpacity(0.2)
                        : AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.isAdmin ? l10n.get('adminPanel') : l10n.get('profile'),
                    style: TextStyle(
                      color: user.isAdmin
                          ? AppColors.secondaryColor
                          : AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      context,
                      l10n.get('purchased'),
                      '${user.totalPurchases ?? 0}',
                      Icons.book,
                    ),
                    _buildStatCard(
                      context,
                      l10n.get('favorites'),
                      '0', // We'll update this with real count later if needed
                      Icons.favorite,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionTile(
                  context,
                  icon: Icons.favorite,
                  title: l10n.get('favorites'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Font Change Option
                _buildActionTile(
                  context,
                  icon: Icons.font_download,
                  title: 'تغيير الخط', // Change Font
                  onTap: () {
                    _showFontSelectionDialog(context);
                  },
                ),

                const SizedBox(height: 12),

                _buildActionTile(
                  context,
                  icon: Icons.settings,
                  title: l10n.get('settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppColors.errorColor,
                  ),
                  title: Text(l10n.get('logout')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.get('logout')),
                        content: Text(
                          l10n.get('confirmDelete'),
                        ), // Reusing generic confirm
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.get('cancel')),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.errorColor,
                            ),
                            child: Text(l10n.get('logout')),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await authProvider.signOut();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: AppColors.errorColor.withOpacity(0.1),
                ),

                if (user.isAdmin) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.get('adminDashboard'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.cloud_upload,
                    title: l10n.get('seedData'),
                    tileColor: Colors.blue.withOpacity(0.1),
                    iconColor: Colors.blue,
                    onTap: () async {
                      try {
                        final bookRepository = BookRepository();
                        await bookRepository.seedBooks();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.get('dataSeeded'))),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${l10n.get('error')}: $e')),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? tileColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: tileColor ?? Colors.grey[100],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(minWidth: 120),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.primaryColor),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _showFontSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer<FontProvider>(
        builder: (context, fontProvider, _) {
          return AlertDialog(
            title: const Text('اختر نوع الخط'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFontRadio(
                  context,
                  title: 'الخط الافتراضي (Cairo)',
                  value: FontProvider.fontCairo,
                  groupValue: fontProvider.currentFont,
                  onChanged: (val) => fontProvider.changeFont(val!),
                ),
                _buildFontRadio(
                  context,
                  title: 'خط التجوال (Tajawal)',
                  value: FontProvider.fontTajawal,
                  groupValue: fontProvider.currentFont,
                  onChanged: (val) => fontProvider.changeFont(val!),
                ),
                _buildFontRadio(
                  context,
                  title: 'خط المراعي (Almarai)',
                  value: FontProvider.fontAlmarai,
                  groupValue: fontProvider.currentFont,
                  onChanged: (val) => fontProvider.changeFont(val!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFontRadio(
    BuildContext context, {
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(title, style: TextStyle(fontFamily: value)),
      value: value,
      groupValue: groupValue,
      onChanged: (val) {
        onChanged(val);
        Navigator.pop(context); // Close dialog on selection
      },
    );
  }
}
