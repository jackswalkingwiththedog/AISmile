import 'package:equatable/equatable.dart';

enum CreateBranchStatus { initial, submitting, success, error }

final class CreateBranchState extends Equatable {
  final String name;
  final String email;
  final String logo;
  final String address;
  final String phone;
  final String description;
  final CreateBranchStatus status;

  factory CreateBranchState.initial() {
    return const CreateBranchState(
      name: '',
      email: '',
      logo: '',
      phone: '',
      address: '',
      description: '',
      status: CreateBranchStatus.initial,
    );
  }

  CreateBranchState copyWith({
    String? name,
    String? logo,
    String? email,
    String? phone,
    String? address,
    String? description,
    CreateBranchStatus? status,
  }) {
    return CreateBranchState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  const CreateBranchState({
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
