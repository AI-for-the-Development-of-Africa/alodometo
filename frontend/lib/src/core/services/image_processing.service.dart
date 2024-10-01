import 'dart:io';
import 'package:dio/dio.dart';

class ImageProcessingService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'https://2610-41-138-91-169.ngrok-free.app/api';

  static Future<Map<String, String>> processImage(File imageFile) async {
    try {
      print(imageFile.path);
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await _dio.post(
        '$_baseUrl/process-image/',
        data: formData,
      );

      print(response);
      if (response.statusCode == 200) {
        return {
          'extractedText': response.data['extractedText'] ?? '',
          'translatedText': response.data['translatedText'] ?? '',
          'audioUrl': response.data['audioUrl'] ?? '',
        };
      } else {
        throw Exception('Failed to process image');
      }
    } catch (e) {
      throw Exception('Error processing image: $e');
    }
  }
}