import 'package:equatable/equatable.dart';

enum EditBranchStatus { initial, submitting, success, error }

final class EditBranchState extends Equatable {
  final String name;
  final String email;
  final String logo;
  final String address;
  final String phone;
  final String description;
  final EditBranchStatus status;

  factory EditBranchState.initial() {
    return const EditBranchState(
      name: '',
      email: '',
      logo: '',
      phone: '',
      address: '',
      description: '',
      status: EditBranchStatus.initial,
    );
  }

  EditBranchState copyWith({
    String? name,
    String? logo,
    String? email,
    String? phone,
    String? address,
    String? description,
    EditBranchStatus? status,
  }) {
    return EditBranchState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  const EditBranchState({
    required this.name,
    required this.email,
    required this.logo,
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
        logo,
      ];
}
