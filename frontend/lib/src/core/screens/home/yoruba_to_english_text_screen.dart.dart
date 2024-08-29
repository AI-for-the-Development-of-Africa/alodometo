import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alo_do_me_to/src/core/providers/yoruba_to_english_provider.dart';
// YorubaToEnglishTextScreen widget
class YorubaToEnglishTextScreen extends ConsumerStatefulWidget {
  const YorubaToEnglishTextScreen({Key? key}) : super(key: key);

  @override
  _YorubaToEnglishTextScreenState createState() => _YorubaToEnglishTextScreenState();
}

class _YorubaToEnglishTextScreenState extends ConsumerState<YorubaToEnglishTextScreen> {
  final TextEditingController _yorubaTextController = TextEditingController();

  @override
  void dispose() {
    _yorubaTextController.dispose();
    super.dispose();
  }

  void _translate() {
    if (_yorubaTextController.text.isNotEmpty) {
      ref.refresh(translateProvider(_yorubaTextController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = ref.watch(translateProvider(_yorubaTextController.text));

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Yoruba to English Translation'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _yorubaTextController,
              decoration: const InputDecoration(
                labelText: 'Enter Yoruba Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _yorubaTextController.text.isEmpty ? null : _translate,
              child: const Text('Translate to English'),
            ),
            const SizedBox(height: 24),
            translation.when(
              data: (data) => Card(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('English Translation:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(data),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                });
                return Text('Translation failed: ${error.toString()}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

