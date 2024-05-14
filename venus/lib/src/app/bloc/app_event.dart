import 'package:venus/src/services/firebase_authentication/entities/firebase_user.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);
  final FirebaseUser user;
}