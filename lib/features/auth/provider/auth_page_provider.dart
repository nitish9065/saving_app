import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_page_provider.g.dart';

@riverpod
class AuthPage extends _$AuthPage {
  @override
  bool build() {
    return true;
  }

  void showLogin(bool showLogin) {
    state = showLogin;
  }
}
