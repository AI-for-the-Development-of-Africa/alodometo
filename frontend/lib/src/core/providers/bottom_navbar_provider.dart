import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavbarNotifier extends StateNotifier<int> {
  BottomNavbarNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavbarProvider =
    StateNotifierProvider<BottomNavbarNotifier, int>((ref) {
  return BottomNavbarNotifier();
});
