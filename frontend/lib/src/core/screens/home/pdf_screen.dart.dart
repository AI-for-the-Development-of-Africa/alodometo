import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:alo_do_me_to/src/core/providers/pdf_provider.dart';

class PdfScreen extends ConsumerStatefulWidget {
  const PdfScreen({super.key});

  @override
  ConsumerState<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends ConsumerState<PdfScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _openFile() async {
    try {
      print('Open file button pressed'); // Debug print
      await ref.read(pdfStateProvider.notifier).loadPdfFile();
    } catch (e) {
      print('Error in _openFile: $e'); // Debug print
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening file: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pdfState = ref.watch(pdfStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          ElevatedButton.icon(
            onPressed: pdfState.isLoading ? null : _openFile,
            icon: const Icon(Icons.folder_open),
            label: const Text('Open PDF'),
          ),
          if (pdfState.pdfBytes != null)
            IconButton(
              onPressed: () => ref.read(pdfStateProvider.notifier).clearPdf(),
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (pdfState.pdfBytes != null)
            SfPdfViewer.memory(
              pdfState.pdfBytes!,
              controller: _pdfViewerController,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading PDF: ${details.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            )
          else
            const Center(
              child: Text(
                'Choose a PDF file to open',
                style: TextStyle(fontSize: 16),
              ),
            ),
          if (pdfState.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (pdfState.error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  pdfState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}