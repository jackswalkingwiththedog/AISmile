import 'package:equatable/equatable.dart';

class BranchEmployee extends Equatable {
  const BranchEmployee({
    required this.uid,
    required this.branchId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.description,
    this.role,
  });

  final String uid;
  final String branchId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? description;
  final String? role;

  static const empty = BranchEmployee(uid: '', branchId: '');
  bool get isEmpty => this == BranchEmployee.empty;
  bool get isNotEmpty => this != BranchEmployee.empty;

  @override
  List<Object?> get props =>
      [uid, branchId, name, email, phone, address, description, role];
}
