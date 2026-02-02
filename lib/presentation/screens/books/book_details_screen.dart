import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/book_model.dart';
import '../../providers/book_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../../core/localization/app_localizations.dart';

class BookDetailsScreen extends StatefulWidget {
  final String bookId;
  
  const BookDetailsScreen({
    super.key,
    required this.bookId,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BookProvider>(context, listen: false)
          .fetchBookById(widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, _) {
          if (bookProvider.isLoading && bookProvider.selectedBook == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final book = bookProvider.selectedBook;
          if (book == null) {
            return Center(
              child: Text(l10n.get('bookNotFound')),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Cover Image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'book_${book.id}',
                    child: Image.network(
                      book.coverImageURL,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.menu_book,
                            size: 100,
                            color: AppColors.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                actions: [
                  Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, _) {
                      final isFavorite = favoriteProvider.isFavorite(book.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          favoriteProvider.toggleFavorite(book);
                        },
                      );
                    },
                  ),
                ],
              ),

              // Book Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Author
                      Text(
                        '${l10n.get('author')}: ${book.author}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Rating
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < book.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.secondaryColor,
                              size: 20,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            '${book.rating} (${book.ratingsCount} ${l10n.get('reviews')})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${book.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Description
                      Text(
                        l10n.get('description'),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Details
                      Text(
                        l10n.get('bookDetails'),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(l10n.get('pages'), '${book.pages}'),
                      _buildDetailRow(l10n.get('category'), book.category),
                      _buildDetailRow(l10n.get('language'), book.language),
                      if (book.publisher != null)
                        _buildDetailRow(l10n.get('publisher'), book.publisher!),
                      _buildDetailRow(l10n.get('bestSellers'), '${book.purchaseCount}'),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: Consumer<BookProvider>(
        builder: (context, bookProvider, _) {
          final book = bookProvider.selectedBook;
          if (book == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      final isInCart = cartProvider.isInCart(book.id);
                      
                      return ElevatedButton.icon(
                        onPressed: isInCart 
                            ? null 
                            : () {
                                cartProvider.addToCart(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.get('addedToCart')),
                                    backgroundColor: AppColors.successColor,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                        icon: Icon(isInCart ? Icons.check : Icons.shopping_cart),
                        label: Text(isInCart ? l10n.get('cart') : l10n.get('addToCart')),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isInCart ? Colors.grey : AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
