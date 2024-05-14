import 'package:equatable/equatable.dart';

enum CreateBranchEmployeeStatus { initial, submitting, success, error }

final class CreateBranchEmployeeState extends Equatable {
  final String name;
  final String email;
  final String role;
  final String address;
  final String phone;
  final String branchId;
  final String description;
  final CreateBranchEmployeeStatus status;

  factory CreateBranchEmployeeState.initial() {
    return const CreateBranchEmployeeState(
      name: '',
      email: '',
      role: '',
      phone: '',
      branchId: '',
      address: '',
      description: '',
      status: CreateBranchEmployeeStatus.initial,
    );
  }

  CreateBranchEmployeeState copyWith({
    String? name,
    String? role,
    String? email,
    String? phone,
    String? branchId,
    String? address,
    String? description,
    CreateBranchEmployeeStatus? status,
  }) {
    return CreateBranchEmployeeState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      branchId: branchId ?? this.branchId,
      role: role ?? this.role,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  const CreateBranchEmployeeState({
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
        description,
        branchId,
        address,
        status,
        role,
      ];
}
