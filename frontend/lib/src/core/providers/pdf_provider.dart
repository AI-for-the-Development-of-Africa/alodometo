import 'package:alo_do_me_to/src/core/services/pdf.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
class PdfState {
  final Uint8List? pdfBytes;
  final bool isLoading;
  final String? error;

  PdfState({
    this.pdfBytes,
    this.isLoading = false,
    this.error,
  });

  PdfState copyWith({
    Uint8List? pdfBytes,
    bool? isLoading,
    String? error,
  }) {
    return PdfState(
      pdfBytes: pdfBytes ?? this.pdfBytes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PdfStateNotifier extends StateNotifier<PdfState> {
  final PdfService _pdfService;

  PdfStateNotifier(this._pdfService) : super(PdfState());

  Future<void> loadPdfFile() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      print('Starting PDF load in provider...'); // Debug print
      
      final bytes = await _pdfService.pickAndLoadPdf();
      print('Bytes received: ${bytes != null}'); // Debug print
      
      if (bytes != null) {
        state = state.copyWith(pdfBytes: bytes, isLoading: false);
        print('PDF loaded successfully'); // Debug print
      } else {
        state = state.copyWith(isLoading: false);
        print('No PDF loaded'); // Debug print
      }
    } catch (e) {
      print('Error in loadPdfFile: $e'); // Debug print
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load PDF: ${e.toString()}',
      );
    }
  }

  void clearPdf() {
    state = PdfState();
  }
}

final pdfServiceProvider = Provider<PdfService>((ref) => PdfService());

final pdfStateProvider = StateNotifierProvider<PdfStateNotifier, PdfState>((ref) {
  final pdfService = ref.watch(pdfServiceProvider);
  return PdfStateNotifier(pdfService);
});
