import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// États de la caméra
abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  final File image;
  CameraLoaded(this.image);
}

class CameraError extends CameraState {
  final String message;
  CameraError(this.message);
}

class CameraNotifier extends StateNotifier<CameraState> {
  final ImagePicker _picker = ImagePicker();

  CameraNotifier() : super(CameraInitial());

  Future<void> pickImageFromGallery() async {
    try {
      state = CameraLoading();
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        state = CameraLoaded(File(pickedFile.path));
      } else {
        state = CameraError("No image selected");
      }
    } catch (e) {
      state = CameraError(e.toString());
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      state = CameraLoading();
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        state = CameraLoaded(File(pickedFile.path));
      } else {
        state = CameraError("No image selected");
      }
    } catch (e) {
      state = CameraError(e.toString());
    }
  }
}

final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});