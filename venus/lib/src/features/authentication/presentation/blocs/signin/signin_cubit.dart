import 'package:bloc/bloc.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/features/authentication/presentation/blocs/signin/signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthenticationRepository _authenticationRepository;
  SignInCubit(this._authenticationRepository) : super(SignInState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignInStatus.initial
      )
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignInStatus.initial
      )
    );
  }

  Future<void> signInFormSubmitting() async {
    if (state.status == SignInStatus.submitting) {
      return;
    }
    emit(
      state.copyWith(
        status: SignInStatus.submitting
      )
    );
    try {
      await _authenticationRepository.signInWithEmailAndPassword(email: state.email, password: state.password);
      emit(
        state.copyWith(
          status: SignInStatus.success
        )
      );
    } catch(_) {
      emit(
        state.copyWith(
          status: SignInStatus.error
        )
      );
    }
  }

  Future<void> signInFormWithGoogleSubmitting() async {
    if (state.status == SignInStatus.submitting) {
      return;
    }
    emit(
      state.copyWith(
        status: SignInStatus.submitting
      )
    );
    try {
      await _authenticationRepository.signInWithGoogle();
      emit(
        state.copyWith(
          status: SignInStatus.success
        )
      );
    } catch(_) {}
  }
}