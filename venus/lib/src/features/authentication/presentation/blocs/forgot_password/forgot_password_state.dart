import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus  {
  initial, submitting, success, error
}

class ForgotPasswordState extends Equatable {
  final String email;
  final ForgotPasswordStatus status;

  const ForgotPasswordState({
    required this.email,
    required this.status,
  });

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      status: ForgotPasswordStatus.initial
    );
  }

  ForgotPasswordState copyWith({
    String? email,
    String? password,
    ForgotPasswordStatus? status,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, status];
}