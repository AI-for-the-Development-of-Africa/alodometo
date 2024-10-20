import 'package:dio/dio.dart';
import 'dart:typed_data';

class VoiceAssistantService {
  final Dio _dio = Dio();
  // final String baseUrl = 'http://10.0.2.2:8000/api';  // Use this for Android emulator
  final String baseUrl = 'https://4cbd-41-138-91-158.ngrok-free.app/api';  // Use ngrok

  Future<String> recordAudio(Uint8List audioBytes) async {
    FormData formData = FormData.fromMap({
      'audio': MultipartFile.fromBytes(audioBytes, filename: 'audio.m4a'),
    });

    try {
      Response response = await _dio.post('$baseUrl/record/', data: formData);
      if (response.statusCode == 200) {
        return response.data['text'];
      } else {
        throw Exception('Failed to record audio');
      }
    } catch (e) {
      throw Exception('Error recording audio: $e');
    }
  }

  Future<Map<String, dynamic>> processAudio(String text) async {
    try {
      Response response = await _dio.post(
        '$baseUrl/process/',
        data: {'text': text},
      );
      if (response.statusCode == 200) {
        return {
          'response': response.data['response'],
          'audio': response.data['audio'],
        };
      } else {
        throw Exception('Failed to process audio');
      }
    } catch (e) {
      throw Exception('Error processing audio: $e');
    }
  }
}


