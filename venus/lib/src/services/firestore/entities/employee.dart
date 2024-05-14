import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  const Employee({
    required this.uid,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    this.role,
  });

  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String? role;

  static const empty = Employee(uid: '');
  bool get isEmpty => this == Employee.empty;
  bool get isNotEmpty => this != Employee.empty;

  @override
  List<Object?> get props =>
      [uid, name, email, phone, address, description, role];
}
