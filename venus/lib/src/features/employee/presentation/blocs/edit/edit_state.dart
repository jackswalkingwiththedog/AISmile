import 'package:equatable/equatable.dart';

enum EditEmployeeStatus { initial, submitting, success, error }

final class EditEmployeeState extends Equatable {
  final String name;
  final String email;
  final String role;
  final String address;
  final String phone;
  final String description;
  final EditEmployeeStatus status;

  factory EditEmployeeState.initial() {
    return const EditEmployeeState(
      name: '',
      email: '',
      role: '',
      phone: '',
      address: '',
      description: '',
      status: EditEmployeeStatus.initial,
    );
  }

  EditEmployeeState copyWith({
    String? name,
    String? role,
    String? email,
    String? phone,
    String? address,
    String? description,
    EditEmployeeStatus? status,
  }) {
    return EditEmployeeState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  const EditEmployeeState({
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
