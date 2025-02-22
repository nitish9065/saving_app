import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loader.g.dart';

@Riverpod(keepAlive: true)
class Loader extends _$Loader {
  @override
  bool build() {
    return false;
  }

  void showLoader() {
    state = true;
  }

  void hideLoader() {
    state = false;
  }
}
