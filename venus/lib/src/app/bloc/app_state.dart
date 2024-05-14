import 'package:equatable/equatable.dart';
import 'package:venus/src/services/firebase_authentication/entities/firebase_user.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

enum Role {
  admin, leadDesigner, designer, printer, reviewer, shipper, branchAdmin, branchDoctor, customer
}

final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = FirebaseUser.empty,
    this.role = Role.customer
  });

  const AppState.authenticated(FirebaseUser user, Role role)
      : this._(status: AppStatus.authenticated, user: user, role: role);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final FirebaseUser user;
  final Role role;
  
  @override
  List<Object> get props => [status, user, role];
}