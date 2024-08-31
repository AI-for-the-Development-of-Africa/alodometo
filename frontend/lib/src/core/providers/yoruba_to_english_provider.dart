import 'package:alo_do_me_to/src/core/services/yoruba_to_english.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final translationServiceProvider = Provider<YorubaToEnglishService>((ref) => YorubaToEnglishService());

final translateProvider = FutureProvider.family<String, String>((ref, yorubaText) async {
  final translationService = ref.read(translationServiceProvider);
  try {
    return await translationService.translateYorubaToEnglish(yorubaText);
  } catch (e) {
    print('Translation error: $e');
    throw e.toString();
  }
});