
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:alo_do_me_to/src/core/providers/audio_provider.dart';

class AudioScreen extends ConsumerWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);

    Widget animationWidget;

if (audioState is AudioInitial || audioState is AudioPermissionGranted) {
      animationWidget = Lottie.asset('assets/animations/initial_state.json');
    } else if (audioState is AudioPermissionDenied) {
      animationWidget = Text('Microphone permission denied');
    } else if (audioState is AudioRecording) {
      animationWidget = Lottie.asset('assets/animations/new_recording.json');
    } else if (audioState is AudioRecorded) {
      animationWidget = Lottie.asset('assets/animations/initial_state.json');
    } else if (audioState is AudioAIResponse) {
      animationWidget = Lottie.asset('assets/animations/new_playing.json');
    } else {
      animationWidget = Container();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child: animationWidget,
            ),
            SizedBox(height: 20),
            if (audioState is AudioAIResponse)
              Text(
                "AI Response: ${(audioState as AudioAIResponse).text}",
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                     if (audioState is AudioInitial || 
                        audioState is AudioPermissionGranted ||
                        audioState is AudioRecorded ||
                        audioState is AudioAIResponse) {
                      ref.read(audioProvider.notifier).startRecording();
                    } else if (audioState is AudioRecording) {
                      ref.read(audioProvider.notifier).stopRecording();
                    }
                  },
                  icon: Icon(Icons.record_voice_over, color: Colors.white),
                  label: Text('Record', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (audioState is AudioAIResponse) {
                      ref.read(audioProvider.notifier).playAIResponse();
                    }
                  },
                  icon: Icon(Icons.play_circle, color: Colors.white),
                  label: Text('Play', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (audioState is AudioRecording) {
                      ref.read(audioProvider.notifier).stopRecording();
                    } else if (audioState is AudioPlaying) {
                      ref.read(audioProvider.notifier).stopPlaying();
                    }
                  },
                  icon: Icon(Icons.stop_circle, color: Colors.white),
                  label: Text('Stop', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}