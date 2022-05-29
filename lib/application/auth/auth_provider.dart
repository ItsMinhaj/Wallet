import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneybag/application/auth/auth_state.dart';
import 'package:moneybag/domain/auth/i_auth_repo.dart';
import 'package:moneybag/domain/auth/login_body.dart';
import 'package:moneybag/domain/auth/signup_body.dart';
import 'package:moneybag/infrastructure/firebase_auth_repo.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(FirebaseAuthRepo());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepo authRepo;
  AuthNotifier(this.authRepo) : super(AuthState.init());

  login(LoginBody body) async {
    state = state.copyWith(loading: true);
    final response = await authRepo.login(body).run();

    state = response
        .fold((l) => state.copyWith(failure: l),
            (r) => state.copyWith(profile: r))
        .copyWith(loading: false);
  }

  registration(SignupBody body) async {
    state = state.copyWith(loading: true);
    final response = await authRepo.registration(body).run();

    state = response
        .fold((l) => state.copyWith(failure: l),
            (r) => state.copyWith(profile: r))
        .copyWith(loading: false);
  }

  checkAuth() async {
    state = state.copyWith(loading: true);
    final response = await authRepo.checkAuth().run();

    state = response
        .fold((l) => state.copyWith(failure: l),
            (r) => state.copyWith(profile: r))
        .copyWith(loading: false);
  }
}
