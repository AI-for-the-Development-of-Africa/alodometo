import 'dart:async';
import 'package:alo_do_me_to/src/core/providers/camera_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);

    return Scaffold(
      body: Center(
        child: _buildContent(cameraState),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showPickerDialog(context),
      //   child: Icon(Icons.add_a_photo),
      // ),
    );
  }

  Widget _buildContent(CameraState state) {
    if (state is CameraInitial) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             ElevatedButton.icon(
              onPressed: () {
                ref.read(cameraProvider.notifier).pickImageFromCamera();
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Camera', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary,),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(cameraProvider.notifier).pickImageFromGallery();
              },
              icon: const Icon(Icons.photo_library, color: Colors.white),
              label: const Text('Gallery', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary,),
              ),
            ),
           
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
          ElevatedButton.icon(
              onPressed: () => _showLanguageSelectionDialog(context),
              icon: const Icon(Icons.play_circle, color: Colors.white),
              label: const Text('Play', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary,),
              ),
            ),
          
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                ref.read(cameraProvider.notifier).pickImageFromCamera();
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Camera', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary,),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(cameraProvider.notifier).pickImageFromGallery();
              },
              icon: const Icon(Icons.photo_library, color: Colors.white),
              label: const Text('Gallery', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary,),
              ),
            ),
            
          ],
        ),
        ],
      );
    } else if (state is CameraError) {
      return Text(state.message);
    }
    return Container();
  }

  void _showPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Select option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Pick from Gallery"),
                onTap: () {
                  ref.read(cameraProvider.notifier).pickImageFromGallery();
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Take a Photo"),
                onTap: () {
                  ref.read(cameraProvider.notifier).pickImageFromCamera();
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text("Yoruba"),
                onTap: () {
                  _listenInLanguage(context, 'yoruba.mp3');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _listenInLanguage(BuildContext context, String audioFile) async {
    await _audioPlayer.play(DeviceFileSource(audioFile));
    setState(() {
      _statusMessage = 'Terminer';
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _statusMessage = '';
      });
    });
  }
}