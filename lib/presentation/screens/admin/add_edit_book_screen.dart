import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/book_model.dart';
import '../../providers/book_provider.dart';

class AddEditBookScreen extends StatefulWidget {
  final BookModel? book;
  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _coverUrlController;
  late TextEditingController _categoryController;
  late TextEditingController _pagesController;
  bool _isFeatured = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _descController = TextEditingController(text: widget.book?.description ?? '');
    _priceController = TextEditingController(text: widget.book?.price.toString() ?? '');
    _coverUrlController = TextEditingController(text: widget.book?.coverImageURL ?? '');
    _categoryController = TextEditingController(text: widget.book?.category ?? 'روايات');
    _pagesController = TextEditingController(text: widget.book?.pages.toString() ?? '200');
    _isFeatured = widget.book?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _coverUrlController.dispose();
    _categoryController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final bookProvider = context.read<BookProvider>();
      final loc = AppLocalizations.of(context);
      
      final bookData = BookModel(
        id: widget.book?.id ?? '',
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0,
        coverImageURL: _coverUrlController.text.trim(),
        category: _categoryController.text.trim(),
        language: loc.isArabic ? 'عربي' : 'English',
        pages: int.tryParse(_pagesController.text) ?? 200,
        isFeatured: _isFeatured,
        createdAt: widget.book?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.book == null) {
        success = await bookProvider.addBook(bookData);
      } else {
        success = await bookProvider.updateBook(bookData);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.tr('bookSaved'))),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(bookProvider.errorMessage ?? loc.tr('error')),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? loc.tr('editBook') : loc.tr('addBook')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // معاينة الغلاف
              if (_coverUrlController.text.isNotEmpty)
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _coverUrlController.text,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: loc.tr('bookTitle'),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (v) => v!.isEmpty ? loc.tr('fieldRequired') : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: loc.tr('author'),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? loc.tr('fieldRequired') : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: loc.tr('description'),
                  prefixIcon: const Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: loc.tr('bookPrice'),
                        prefixIcon: const Icon(Icons.attach_money),
                        suffixText: loc.tr('currency'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v!.isEmpty) return loc.tr('fieldRequired');
                        if (double.tryParse(v) == null) return loc.isArabic ? 'رقم غير صحيح' : 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _pagesController,
                      decoration: InputDecoration(
                        labelText: loc.tr('bookPages'),
                        prefixIcon: const Icon(Icons.pages),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _coverUrlController,
                decoration: InputDecoration(
                  labelText: loc.tr('bookCoverUrl'),
                  prefixIcon: const Icon(Icons.image),
                  hintText: 'https://example.com/cover.jpg',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: loc.tr('category'),
                  prefixIcon: const Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: Text(loc.tr('featuredBook')),
                subtitle: Text(
                  loc.isArabic 
                      ? 'يظهر في قسم الكتب المميزة'
                      : 'Appears in featured books section',
                ),
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
                secondary: Icon(
                  Icons.star,
                  color: _isFeatured ? Colors.amber : Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveBook,
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? loc.tr('update') : loc.tr('add')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
