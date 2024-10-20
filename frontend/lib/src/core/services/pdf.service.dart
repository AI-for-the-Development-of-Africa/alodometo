import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfService {
  Future<Uint8List?> pickAndLoadPdf() async {
    try {
      print('Starting PDF pick process...');

      if (!kIsWeb) {
        if (Platform.isAndroid) {
          print('Requesting Android permissions...');
          final status = await Permission.storage.request();
          print('Permission status: $status');
          
          if (!status.isGranted) {
            throw 'Storage permission is required to pick files';
          }
        }
      }

      print('Attempting to pick file...');
      
      // More specific file picking configuration
      FilePickerResult? result;
      
      if (kIsWeb) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false,
          withData: true,
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false,
        );
      }

      print('Pick result: ${result?.files.length ?? 'null'}');

      if (result != null && result.files.isNotEmpty) {
        print('File picked: ${result.files.first.name}');
        
        if (kIsWeb) {
          return result.files.first.bytes;
        } else {
          final path = result.files.first.path;
          if (path != null) {
            final file = File(path);
            final bytes = await file.readAsBytes();
            print('File bytes length: ${bytes.length}');
            return bytes;
          }
        }
      }
      
      return null;
    } catch (e) {
      print('Error in pickAndLoadPdf: $e');
      rethrow;
    }
  }
}