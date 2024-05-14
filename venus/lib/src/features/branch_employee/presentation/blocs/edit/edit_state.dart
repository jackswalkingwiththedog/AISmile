import 'package:equatable/equatable.dart';

enum EditBranchEmployeeStatus { initial, submitting, success, error }

final class EditBranchEmployeeState extends Equatable {
  final String name;
  final String email;
  final String role;
  final String branchId;
  final String address;
  final String phone;
  final String description;
  final EditBranchEmployeeStatus status;

  factory EditBranchEmployeeState.initial() {
    return const EditBranchEmployeeState(
      name: '',
      email: '',
      role: '',
      phone: '',
      branchId: '',
      address: '',
      description: '',
      status: EditBranchEmployeeStatus.initial,
    );
  }

  EditBranchEmployeeState copyWith({
    String? name,
    String? role,
    String? email,
    String? phone,
    String? branchId,
    String? address,
    String? description,
    EditBranchEmployeeStatus? status,
  }) {
    return EditBranchEmployeeState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      branchId: branchId ?? this.branchId,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  const EditBranchEmployeeState({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.branchId,
    required this.address,
    required this.status,
    required this.description,
  });

  @override
  List<Object> get props => [
        name,
        email,
        phone,
        branchId,
        description,
        address,
        status,
        role,
      ];
}
