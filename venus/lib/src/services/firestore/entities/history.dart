import 'package:equatable/equatable.dart';

class History extends Equatable {
  const History(
      {required this.id,
      this.orderId,
      this.uid,
      this.role,
      this.createAt,
      this.message,
      this.name,
      this.status,
      this.procedure});

  final String id;
  final String? orderId;
  final String? uid;
  final String? role;
  final String? message;
  final String? createAt;
  final String? procedure;
  final String? name;
  final String? status;

  static const empty = History(id: '');
  bool get isEmpty => this == History.empty;
  bool get isNotEmpty => this != History.empty;

  @override
  List<Object?> get props =>
      [id, orderId, uid, role, procedure, message, createAt, name, status];
}
