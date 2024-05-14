import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:venus/src/app/bloc/app_event.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/services/firebase_authentication/entities/firebase_user.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/services/firestore/repository/user_repository.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(
                  authenticationRepository.currentUser, Role.customer)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;

  late final StreamSubscription<FirebaseUser> _userSubscription;

  Future<void> _onUserChanged(
      AppUserChanged event, Emitter<AppState> emit) async {
    if (event.user.isNotEmpty) {
      late Role role;
      final user = await UserRepository().getUser(event.user.uid);
      if (user.role == "admin") {
        role = Role.admin;
      } else if (user.role == "lead-designer") {
        role = Role.leadDesigner;
      } else if (user.role == "branch-doctor") {
        role = Role.branchDoctor;
      } else if (user.role == "branch-admin") {
        role = Role.branchAdmin;
      } else if (user.role == "designer") {
        role = Role.designer;
      } else if (user.role == "reviewer") {
        role = Role.reviewer;
      } else if (user.role == "shipper") {
        role = Role.shipper;
      } else if (user.role == "printer") {
        role = Role.printer;
      } else {
        role = Role.customer;
      }


      if (_authenticationRepository.currentUser.isNotEmpty) {
        emit(AppState.authenticated(
            _authenticationRepository.currentUser, role));
        return;
      }

      emit(AppState.authenticated(event.user, role));
    } else {
      emit(
        const AppState.unauthenticated(),
      );
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
