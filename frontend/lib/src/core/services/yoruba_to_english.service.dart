// YorubaToEnglishTextScreen widget code remains the same as in the previous artifact

// Add this at the end of the file:

import 'package:dio/dio.dart';

class YorubaToEnglishService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://2610-41-138-91-169.ngrok-free.app/api'; 
  Future<String> translateYorubaToEnglish(String yorubaText) async {
    try {
      print('Attempting to translate: $yorubaText');
      print('Using URL: $baseUrl/translate-yoruba/');
      
      Response response = await _dio.post(
        // '$baseUrl/llama-translate-yoruba/',
        '$baseUrl/translate-yoruba/',
        data: {'text': yorubaText},
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['english_translation'] ?? 'Translation not found in response';
      } else {
        throw Exception('Translation failed: ${response.data['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('DioException type: ${e.type}');
        print('DioException error: ${e.error}');
        if (e.response != null) {
          print('DioException response: ${e.response!.data}');
        }
        if (e.response?.statusCode == 404) {
          throw 'Server not found. Please check your internet connection and ensure the server is running.';
        }
      }
      throw 'Error translating text: ${e.toString()}';
    }
  }
}