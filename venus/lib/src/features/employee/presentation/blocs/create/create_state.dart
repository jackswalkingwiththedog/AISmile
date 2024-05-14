import 'package:equatable/equatable.dart';

enum CreateEmployeeStatus { initial, submitting, success, error }

final class CreateEmployeeState extends Equatable {
  final String name;
  final String email;
  final String role;
  final String address;
  final String phone;
  final String description;
  final CreateEmployeeStatus status;

  factory CreateEmployeeState.initial() {
    return const CreateEmployeeState(
      name: '',
      email: '',
      role: '',
      phone: '',
      address: '',
      description: '',
      status: CreateEmployeeStatus.initial,
    );
  }

  CreateEmployeeState copyWith({
    String? name,
    String? role,
    String? email,
    String? phone,
    String? address,
    String? description,
    CreateEmployeeStatus? status,
  }) {
    return CreateEmployeeState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  const CreateEmployeeState({
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
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
        address,
        status,
        role,
      ];
}
