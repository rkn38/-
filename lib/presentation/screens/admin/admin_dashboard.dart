import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../../core/utils/data_seeder.dart';
import '../../../data/repositories/auth_repository.dart';
import 'add_edit_book_screen.dart';
import 'create_admin_screen.dart';

/// لوحة تحكم المدير الاحترافية
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  Map<String, int> _userStats = {'total': 0, 'admins': 0, 'users': 0};
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // تحميل الكتب
    Future.microtask(() {
      context.read<BookProvider>().fetchAllBooks();
    });
    
    // تحميل إحصائيات المستخدمين
    try {
      final authRepo = AuthRepository();
      final stats = await authRepo.getUserStats();
      if (mounted) {
        setState(() {
          _userStats = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStats = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr('adminDashboard')),
        actions: [
          // زر تبديل اللغة
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: loc.tr('changeLanguage'),
            onPressed: () => localeProvider.toggleLocale(),
          ),
          // زر تعبئة البيانات
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined),
            tooltip: loc.tr('seedData'),
            onPressed: () async {
              await DataSeeder.seedAll();
              if (mounted) {
                context.read<BookProvider>().fetchAllBooks();
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.tr('dataSeeded'))),
                );
              }
            },
          ),
          // زر تسجيل الخروج
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: loc.tr('logout'),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      
      // الشريط الجانبي
      drawer: _buildDrawer(loc),
      
      // المحتوى
      body: _getSelectedPage(loc),
      
      // شريط التنقل السفلي
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: loc.tr('statistics'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: loc.tr('manageBooks'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: const Icon(Icons.admin_panel_settings),
            label: loc.tr('admins'),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedPage(AppLocalizations loc) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardPage(loc);
      case 1:
        return _buildBooksPage(loc);
      case 2:
        return _buildAdminsPage(loc);
      default:
        return _buildDashboardPage(loc);
    }
  }

  // ========== صفحة الإحصائيات ==========
  Widget _buildDashboardPage(AppLocalizations loc) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ترحيب
              _buildWelcomeCard(loc),
              const SizedBox(height: 20),
              
              // إحصائيات
              Text(
                loc.tr('statistics'),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              _buildStatsGrid(bookProvider, loc),
              
              const SizedBox(height: 24),
              
              // إجراءات سريعة
              Text(
                loc.isArabic ? 'إجراءات سريعة' : 'Quick Actions',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              _buildQuickActions(loc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(AppLocalizations loc) {
    final authProvider = context.watch<AuthProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${loc.tr('welcomeBack')} 👋',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            authProvider.currentUser?.displayName ?? loc.tr('adminPanel'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            authProvider.currentUser?.email ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BookProvider bookProvider, AppLocalizations loc) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          title: loc.tr('totalBooks'),
          value: bookProvider.allBooks.length.toString(),
          icon: Icons.book,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: loc.tr('totalUsers'),
          value: _isLoadingStats ? '...' : _userStats['users'].toString(),
          icon: Icons.people,
          color: Colors.green,
        ),
        _buildStatCard(
          title: loc.tr('admins'),
          value: _isLoadingStats ? '...' : _userStats['admins'].toString(),
          icon: Icons.admin_panel_settings,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: loc.tr('bestSellers'),
          value: bookProvider.allBooks.where((b) => b.purchaseCount > 10).length.toString(),
          icon: Icons.trending_up,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            title: loc.tr('addBook'),
            icon: Icons.add_circle_outline,
            color: AppColors.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditBookScreen()),
              ).then((_) => context.read<BookProvider>().fetchAllBooks());
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            title: loc.tr('createAdmin'),
            icon: Icons.person_add,
            color: AppColors.secondaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateAdminScreen()),
              ).then((_) => _loadData());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ========== صفحة الكتب ==========
  Widget _buildBooksPage(AppLocalizations loc) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        if (bookProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // شريط العنوان
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${loc.tr('manageBooks')} (${bookProvider.allBooks.length})',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddEditBookScreen()),
                      ).then((_) => bookProvider.fetchAllBooks());
                    },
                    icon: const Icon(Icons.add),
                    label: Text(loc.tr('add')),
                  ),
                ],
              ),
            ),
            
            // قائمة الكتب
            Expanded(
              child: bookProvider.allBooks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(loc.tr('noData')),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bookProvider.allBooks.length,
                      itemBuilder: (context, index) {
                        final book = bookProvider.allBooks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: book.coverImageURL.startsWith('http')
                                  ? Image.network(
                                      book.coverImageURL,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40),
                                    )
                                  : Container(
                                      width: 50,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.book),
                                    ),
                            ),
                            title: Text(
                              book.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(book.author),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (book.isFeatured)
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  color: AppColors.primaryColor,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditBookScreen(book: book),
                                      ),
                                    ).then((_) => bookProvider.fetchAllBooks());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: AppColors.errorColor,
                                  onPressed: () => _confirmDeleteBook(book.id, loc),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // ========== صفحة المدراء ==========
  Widget _buildAdminsPage(AppLocalizations loc) {
    return FutureBuilder<List<dynamic>>(
      future: context.read<AuthProvider>().getAdminsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final admins = snapshot.data ?? [];

        return Column(
          children: [
            // شريط العنوان
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${loc.tr('manageAdmins')} (${admins.length})',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateAdminScreen()),
                      ).then((_) => setState(() {}));
                    },
                    icon: const Icon(Icons.person_add),
                    label: Text(loc.tr('add')),
                  ),
                ],
              ),
            ),
            
            // قائمة المدراء
            Expanded(
              child: admins.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(loc.tr('noAdmins')),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: admins.length,
                      itemBuilder: (context, index) {
                        final admin = admins[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                              child: Text(
                                (admin.displayName ?? 'A')[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              admin.displayName ?? loc.tr('adminPanel'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(admin.email ?? ''),
                            trailing: const Icon(
                              Icons.verified_user,
                              color: AppColors.successColor,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // ========== الشريط الجانبي ==========
  Widget _buildDrawer(AppLocalizations loc) {
    final authProvider = context.watch<AuthProvider>();
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            accountName: Text(
              authProvider.currentUser?.displayName ?? loc.tr('adminPanel'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(authProvider.currentUser?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (authProvider.currentUser?.displayName ?? 'A')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(loc.tr('statistics')),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: Text(loc.tr('manageBooks')),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(loc.tr('manageAdmins')),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.tr('changeLanguage')),
            trailing: Text(
              context.watch<LocaleProvider>().languageName,
              style: const TextStyle(color: AppColors.primaryColor),
            ),
            onTap: () {
              context.read<LocaleProvider>().toggleLocale();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.errorColor),
            title: Text(
              loc.tr('logout'),
              style: const TextStyle(color: AppColors.errorColor),
            ),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBook(String bookId, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.tr('deleteBook')),
        content: Text(loc.tr('confirmDeleteBook')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BookProvider>().deleteBook(bookId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text(loc.tr('delete')),
          ),
        ],
      ),
    );
  }
}
