import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/book_provider.dart';
import '../books/read_book_screen.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        Provider.of<PurchaseProvider>(
          context,
          listen: false,
        ).fetchUserPurchases(authProvider.currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('myLibrary')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              if (authProvider.isAuthenticated &&
                  authProvider.currentUser != null) {
                Provider.of<PurchaseProvider>(
                  context,
                  listen: false,
                ).fetchUserPurchases(authProvider.currentUser!.uid);
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.get('loginToSeeLibrary'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return Consumer<PurchaseProvider>(
            builder: (context, purchaseProvider, _) {
              if (purchaseProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (purchaseProvider.userPurchases.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books,
                        size: 80,
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.get('emptyLibrary'),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.get('startShopping'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: purchaseProvider.userPurchases.length,
                itemBuilder: (context, index) {
                  final purchase = purchaseProvider.userPurchases[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          purchase.bookCoverURL,
                          width: 50,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 50,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book),
                          ),
                        ),
                      ),
                      title: Text(
                        purchase.bookTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        // Date formatting could be better
                        purchase.purchaseDate.toString().split(' ')[0],
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          // Find book to get PDF URL
                          final bookProvider = Provider.of<BookProvider>(
                            context,
                            listen: false,
                          );

                          String? pdfUrl;
                          try {
                            final foundBook = bookProvider.allBooks.firstWhere(
                              (b) => b.id == purchase.bookId,
                            );
                            pdfUrl = foundBook.pdfURL;
                          } catch (e) {
                            // Not found in local list
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Book details not found locally. Please refresh home.',
                                ),
                              ),
                            );
                            return;
                          }

                          if (pdfUrl != null && pdfUrl.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadBookScreen(
                                  bookTitle: purchase.bookTitle,
                                  pdfUrl: pdfUrl!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'PDF not available for this book',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(l10n.get('readNow')),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
