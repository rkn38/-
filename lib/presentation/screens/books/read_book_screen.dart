import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/constants/app_colors.dart';

class ReadBookScreen extends StatelessWidget {
  final String bookTitle;
  final String pdfUrl;

  const ReadBookScreen({
    super.key,
    required this.bookTitle,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: pdfUrl.isNotEmpty
          ? SfPdfViewer.network(
              pdfUrl,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading PDF: ${details.error}'),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
              },
            )
          : const Center(child: Text('PDF URL is not available')),
    );
  }
}
