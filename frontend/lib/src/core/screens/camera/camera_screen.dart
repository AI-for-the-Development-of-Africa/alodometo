import 'dart:async';
import 'dart:io';
import 'package:alo_do_me_to/src/core/providers/camera_provider.dart';
import 'package:alo_do_me_to/src/core/services/image_processing.service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CameraScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  String _statusMessage = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _extractedText = '';
  String _translatedText = '';
  String _audioUrl = '';

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    return Scaffold(
      body: Center(
        child: _buildContent(cameraState),
      ),
    );
  }

  Widget _buildContent(CameraState state) {
    if (state is CameraInitial) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(Icons.camera_alt, 'Camera', () {
              ref.read(cameraProvider.notifier).pickImageFromCamera();
            }),
            _buildButton(Icons.photo_library, 'Gallery', () {
              ref.read(cameraProvider.notifier).pickImageFromGallery();
            }),
          ],
        ),
      );
    } else if (state is CameraLoading) {
      return const CircularProgressIndicator();
    } else if (state is CameraLoaded) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.file(
            state.image,
            height: 300,
          ),
          const SizedBox(height: 20),
          _buildButton(Icons.play_circle, 'Process Image', () => _processImage(state.image)),
          // if (_extractedText.isNotEmpty) Text('Extracted Text: $_extractedText'),

      //     if (_extractedText.isNotEmpty)
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Text('Extracted Text: $_extractedText'),
      // ),
    if (_translatedText.isNotEmpty)
      Card(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Translated Text:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                _translatedText,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
          // Text('Translated Text: $_translatedText'),
          if (_audioUrl.isNotEmpty)
            _buildButton(Icons.volume_up, 'Play Audio', () => _audioPlayer.play(UrlSource(_audioUrl))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(Icons.camera_alt, 'Camera', () {
                ref.read(cameraProvider.notifier).pickImageFromCamera();
              }),
              _buildButton(Icons.photo_library, 'Gallery', () {
                ref.read(cameraProvider.notifier).pickImageFromGallery();
              }),
            ],
          ),
        ],
      );
    } else if (state is CameraError) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(Icons.camera_alt, 'Camera', () {
              ref.read(cameraProvider.notifier).pickImageFromCamera();
            }),
            _buildButton(Icons.photo_library, 'Gallery', () {
              ref.read(cameraProvider.notifier).pickImageFromGallery();
            }),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Future<void> _processImage(File imageFile) async {
    try {
    print("Hello");
      setState(() {
        _statusMessage = 'Processing image...';
      });

      final result = await ImageProcessingService.processImage(imageFile);
      print(result);

      setState(() {
        _extractedText = result['extractedText'] ?? '';
        _translatedText = result['translatedText'] ?? '';
        _audioUrl = result['audioUrl'] ?? '';
        _statusMessage = 'Image processed successfully';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error processing image: $e';
      });
    }

    Timer(const Duration(seconds: 10), () {
      setState(() {
        _statusMessage = '';
      });
    });
  }
}