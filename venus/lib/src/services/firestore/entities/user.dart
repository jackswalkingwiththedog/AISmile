import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.uid,
    this.role,
  });

  final String uid;
  final String? role;

  static const empty = User(uid: '');
  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
        uid,
        role,
      ];
}
