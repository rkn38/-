import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('settings')),
      ),
      body: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Language Selection
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language, color: AppColors.primaryColor),
                        title: Text(l10n.get('languageSettings')),
                        subtitle: Text(
                          localeProvider.isArabic ? 'العربية' : 'English',
                        ),
                      ),
                      const Divider(),
                      RadioListTile<Locale>(
                        title: const Text('العربية'),
                        value: const Locale('ar'),
                        groupValue: localeProvider.locale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            localeProvider.setLocale(value);
                          }
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                      RadioListTile<Locale>(
                        title: const Text('English'),
                        value: const Locale('en'),
                        groupValue: localeProvider.locale,
                        onChanged: (Locale? value) {
                          if (value != null) {
                            localeProvider.setLocale(value);
                          }
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // App Info
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppColors.primaryColor),
                      title: Text(l10n.get('about')),
                      onTap: () {
                        // Show About dialog
                        showAboutDialog(
                          context: context,
                          applicationName: l10n.get('appName'),
                          applicationVersion: '1.0.0',
                          applicationIcon: const Icon(
                            Icons.menu_book,
                            size: 40,
                            color: AppColors.primaryColor,
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.verified_user_outlined, color: AppColors.primaryColor),
                      title: Text(l10n.get('appVersion')),
                      trailing: const Text('1.0.0'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
