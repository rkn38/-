import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/book_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../cart/cart_screen.dart';
import '../library/my_library_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_dashboard.dart';
import '../books/book_details_screen.dart';
import '../../../core/localization/app_localizations.dart';
import '../library/favorites_screen.dart';
import '../profile/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // الفئة المختارة حالياً
  int _selectedCategoryIndex = 0;

  // قائمة الفئات بالعربي للـ DB
  static const List<String> _categoryDBKeys = [
    'الكل',
    'روايات',
    'علمية',
    'دينية',
    'تقنية',
    'تطوير ذاتي',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final bookProvider = context.read<BookProvider>();
      bookProvider.fetchFeaturedBooks();
      bookProvider.fetchAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // قائمة الفئات المترجمة للعرض
    final List<String> categories = [
      l10n.get('allCategories'),
      l10n.get('novels'),
      l10n.get('scientific'),
      l10n.get('religious'),
      l10n.get('technology'),
      l10n.get('selfDevelopment'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('appName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isLoading && bookProvider.allBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.get('loading')),
                ],
              ),
            );
          }

          if (bookProvider.errorMessage != null &&
              bookProvider.allBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(bookProvider.errorMessage!),
                  ElevatedButton(
                    onPressed: () => bookProvider.fetchAllBooks(),
                    child: Text(l10n.get('tryAgain')),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Books Section
                if (bookProvider.featuredBooks.isNotEmpty) ...[
                  _buildSectionTitle(l10n.get('featuredBooks')),
                  _buildFeaturedBooks(bookProvider.featuredBooks),
                ],

                const SizedBox(height: 24),

                // Categories
                _buildSectionTitle(l10n.get('categories')),
                _buildCategories(categories),

                const SizedBox(height: 24),

                // All Books / Best Sellers
                _buildSectionTitle(l10n.get('bestSellers')),
                _buildBooksGrid(bookProvider.filteredBooks),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primaryColor,
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? 'مستخدم',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (authProvider.isAdmin)
                ListTile(
                  leading: const Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    l10n.get('adminDashboard'),
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboard(),
                      ),
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.home),
                title: Text(l10n.get('home')),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.library_books),
                title: Text(l10n.get('myLibrary')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyLibraryScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(l10n.get('favorites')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(l10n.get('cart')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(l10n.get('profile')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(l10n.get('settings')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.errorColor),
                title: Text(
                  l10n.get('logout'),
                  style: const TextStyle(color: AppColors.errorColor),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.get('logout')),
                      content: Text(l10n.get('confirmDelete')),
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

                  if (confirm == true && context.mounted) {
                    await authProvider.signOut();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    // Need context for l10n to localized 'View All' but it is a string arg method
    // We can just rely on the parent build context if we move this into the build method or pass context
    // For now, let's just leave it simple or refactor slightly.
    // Actually, simpler to just use Builder or hardcoded context if available, but it's a mixin method.
    // Let's pass the build context to use l10n or just update the calls to pass the localized 'View All' ?
    // No, let's just grab l10n locally or from class if it was stateful properly or just ...
    // The cleanest way is to pass l10n or use a Builder.
    // Since I cannot change the signature easily in `multi_replace` without rigorous checking,
    // I made a mistake assuming I can access l10n easily inside this helper without context if it's not passed.
    // Wait, the method is inside the State class, so I can use `context`.

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(onPressed: () {}, child: Text(l10n.get('viewAll'))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBooks(List<BookModel> books) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return _buildFeaturedBookCard(books[index]);
        },
      ),
    );
  }

  Widget _buildFeaturedBookCard(BookModel book) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(bookId: book.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                image: book.coverImageURL.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(book.coverImageURL),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: book.coverImageURL.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.book,
                        size: 60,
                        color: AppColors.primaryColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(List<String> categories) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryChip(index, categories);
        },
      ),
    );
  }

  Widget _buildCategoryChip(int index, List<String> categories) {
    final isSelected = index == _selectedCategoryIndex;
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(categories[index]),
        selected: isSelected,
        onSelected: (value) {
          if (value) {
            setState(() {
              _selectedCategoryIndex = index;
            });
            // إرسال اسم الفئة بالعربي للـ DB
            context.read<BookProvider>().fetchBooksByCategory(
              _categoryDBKeys[index],
            );
          } else if (_selectedCategoryIndex == index && index != 0) {
            // العودة لـ "الكل" عند إلغاء التحديد
            setState(() {
              _selectedCategoryIndex = 0;
            });
            context.read<BookProvider>().fetchBooksByCategory(
              _categoryDBKeys[0],
            );
          }
        },
        selectedColor: AppColors.primaryColor,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBooksGrid(List<BookModel> books) {
    if (books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(AppLocalizations.of(context).get('noData')),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return _buildBookCard(books[index]);
        },
      ),
    );
  }

  Widget _buildBookCard(BookModel book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(bookId: book.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: book.coverImageURL.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(book.coverImageURL),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: book.coverImageURL.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.menu_book,
                          size: 50,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        book.rating.toString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${book.price}',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
