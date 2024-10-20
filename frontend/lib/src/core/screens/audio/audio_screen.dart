import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:alo_do_me_to/src/core/providers/audio_provider.dart';

class AudioScreen extends ConsumerWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);

    Widget animationWidget;

    if (audioState is AudioInitial || audioState is AudioPermissionGranted) {
      animationWidget = Lottie.asset('assets/animations/initial_state.json');
    } else if (audioState is AudioPermissionDenied) {
      animationWidget = const Text('Microphone permission denied');
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
            SizedBox(
              height: 200,
              child: animationWidget,
            ),
            const SizedBox(height: 20),
            if (audioState is AudioAIResponse)
              Text(
                "AI Response: ${(audioState).text}",
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
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
                  icon: Icon(
                      audioState is AudioInitial ||
                              audioState is AudioPermissionGranted ||
                              AudioState is AudioRecorded ||
                              audioState is AudioAIResponse
                          ? Icons.record_voice_over
                          : Icons.stop_circle,
                      color: Colors.white),
                  label: Text(
                      audioState is AudioInitial ||
                              audioState is AudioPermissionGranted ||
                              AudioState is AudioRecorded ||
                              audioState is AudioAIResponse
                          ? 'Record'
                          : 'Stop',
                      style: const TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
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
                  icon: const Icon(Icons.play_circle, color: Colors.white),
                  label: const Text('Play AI Response', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     if (audioState is AudioRecording) {
                //       ref.read(audioProvider.notifier).stopRecording();
                //     } else if (audioState is AudioPlaying) {
                //       ref.read(audioProvider.notifier).stopPlaying();
                //     }
                //   },
                //   icon: Icon(Icons.stop_circle, color: Colors.white),
                //   label: Text('Stop', style: TextStyle(color: Colors.white)),
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //       Theme.of(context).colorScheme.primary,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
