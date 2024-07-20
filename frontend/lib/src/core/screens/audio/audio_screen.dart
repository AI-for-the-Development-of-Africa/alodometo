// import 'dart:math';

// import 'package:alo_do_me_to/src/core/components/my_circular_icon_background.dart';
// import 'package:alo_do_me_to/src/core/components/my_circular_image_background.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';

// class AudioScreen extends StatefulWidget {
//   const AudioScreen({super.key});

//   @override
//   State<AudioScreen> createState() => _AudioScreenState();
// }

// class _AudioScreenState extends State<AudioScreen> {
//     final AudioPlayer _audioPlayer = AudioPlayer();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // LottieBuilder.asset(
//             //       "assets/animations/recording.json",
//             //       // animate: isAnimating,
//             //       width: 150,
//             //       height: 150,
//             //     ),
//             MyCircularIconBackground(
//                 size: 200,
//                 icon: Icons.mic,
//                 color: Theme.of(context).colorScheme.primary),
//             Text("Ask a question",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.lato(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xff001B44))),
//            ],
//         ),
//       ),
//     );
//   }
// }

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

    ref.listen<AudioState>(audioProvider, (previous, next) {
      if (next is AudioPlaying) {
        _audioPlayer.play(DeviceFileSource(next.path));
        _audioPlayer.onPlayerComplete.listen((_) {
          ref.read(audioProvider.notifier).stopPlaying();
        });
      } else if (next is AudioRecorded) {
        _audioPlayer.stop();
      }
    });

    Widget animationWidget;

    if (audioState is AudioInitial || audioState is AudioPermissionGranted) {
      animationWidget = Lottie.asset('assets/animations/initial_state.json');
    } else if (audioState is AudioPermissionDenied) {
      animationWidget = Text('Microphone permission denied');
    } else if (audioState is AudioRecording) {
      animationWidget = Lottie.asset('assets/animations/new_recording.json');
    } else if (audioState is AudioRecorded) {
      animationWidget = Lottie.asset('assets/animations/initial_state.json');
    } else if (audioState is AudioPlaying) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (audioState is AudioInitial || 
                        audioState is AudioPermissionGranted ||
                        audioState is AudioRecorded) {
                      ref.read(audioProvider.notifier).startRecording();
                    } else if (audioState is AudioRecording) {
                      ref.read(audioProvider.notifier).stopRecording();
                    }
                  },
                  icon: Icon(Icons.record_voice_over, color: Colors.white),
                  label: Text('Start', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (audioState is AudioRecorded) {
                      ref.read(audioProvider.notifier).startPlaying();
                    } else if (audioState is AudioPlaying) {
                      ref.read(audioProvider.notifier).stopPlaying();
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