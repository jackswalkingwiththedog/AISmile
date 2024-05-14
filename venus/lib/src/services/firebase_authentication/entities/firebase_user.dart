import 'package:equatable/equatable.dart';

class FirebaseUser extends Equatable {
  const FirebaseUser({
    required this.uid,
    this.tenantId,
    this.email,
    this.refreshToken,
    this.phoneNumber,
    this.metadata,
    this.isAnonymous,
    this.isEmailVerified,
    this.displayName,
    this.photoURL,
  });

  final String uid;
  final String? tenantId;
  final String? refreshToken;
  final String? email;
  final String? phoneNumber;
  final String? metadata;
  final bool? isAnonymous;
  final bool? isEmailVerified;
  final String? displayName;
  final String? photoURL;

  static const empty = FirebaseUser(uid: '');
  bool get isEmpty => this == FirebaseUser.empty;
  bool get isNotEmpty => this != FirebaseUser.empty;

  @override
  List<Object?> get props => [
        uid,
        email,
        tenantId,
        refreshToken,
        phoneNumber,
        isEmailVerified,
        photoURL,
        displayName,
        metadata,
        isAnonymous
      ];
}
