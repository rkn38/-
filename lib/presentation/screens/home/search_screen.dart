import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/book_provider.dart';
import '../books/book_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // استخدام PopScope للتأكد من مسح الفلترة عند الخروج
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          // إعادة تعيين الفلترة عند الخروج
          Future.microtask(() {
            if (context.mounted) {
              Provider.of<BookProvider>(context, listen: false).clearFilters();
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Custom Search Header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: l10n.get('searchBooks'),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () {
                                      _searchController.clear();
                                      Provider.of<BookProvider>(
                                        context,
                                        listen: false,
                                      ).searchBooks('');
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {}); // لتحديث أيقونة المسح
                            Provider.of<BookProvider>(
                              context,
                              listen: false,
                            ).searchBooks(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Results
              Expanded(
                child: Consumer<BookProvider>(
                  builder: (context, bookProvider, _) {
                    if (bookProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final books = bookProvider.filteredBooks;

                    if (books.isEmpty && _searchController.text.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 100,
                              color: Colors.grey[200],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.get('noData'),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: books.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 30),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailsScreen(bookId: book.id),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  book.coverImageURL,
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.book,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      book.author,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber[700],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${book.rating}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${book.price}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
