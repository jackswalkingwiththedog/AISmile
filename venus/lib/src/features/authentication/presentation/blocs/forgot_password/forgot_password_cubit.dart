import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/authentication/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthenticationRepository _authenticationRepository;
  ForgotPasswordCubit(this._authenticationRepository) : super(ForgotPasswordState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: ForgotPasswordStatus.initial
      )
    );
  }

  Future<void> forgotPasswordSubmitting() async {
    if (state.status == ForgotPasswordStatus.submitting) {
      return;
    }
    emit(
      state.copyWith(
        status: ForgotPasswordStatus.submitting
      )
    );
    try {
      await _authenticationRepository.sendPasswordResetEmail(email: state.email);
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success
        )
      );
    } catch(_) {}
  }
}