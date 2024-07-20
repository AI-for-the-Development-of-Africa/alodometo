import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

// Définition des états
abstract class AudioState {}
class AudioInitial extends AudioState {}
class AudioPermissionGranted extends AudioState {}
class AudioPermissionDenied extends AudioState {}
class AudioRecording extends AudioState {
  final String path;
  AudioRecording({required this.path});
}
class AudioRecorded extends AudioState {
  final String path;
  AudioRecorded(this.path);
}
class AudioPlaying extends AudioState {
  final String path;
  AudioPlaying({required this.path});
}

class AudioNotifier extends StateNotifier<AudioState> {
  final _record = AudioRecorder();
   String? _lastRecordedPath;

  AudioNotifier() : super(AudioInitial()) {
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      state = AudioPermissionGranted();
    } else {
      state = AudioPermissionDenied();
    }
  }

  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/audio_recording.m4a';
      state = AudioRecording(path: path);
      await _record.start(
        const RecordConfig(),
        path: path,
      );
    }
  }

 Future<void> stopRecording() async {
    final path = await _record.stop();
    if (path != null) {
      _lastRecordedPath = path;
      state = AudioRecorded(path);
    }
  }

 void startPlaying() {
    if (_lastRecordedPath != null) {
      state = AudioPlaying(path: _lastRecordedPath!);
    }
  }

  void stopPlaying() {
    if (state is AudioPlaying) {
      state = AudioRecorded((state as AudioPlaying).path);
    }
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier();
});