import 'package:equatable/equatable.dart';

enum CreateCustomerStatus { initial, submitting, success, error }

final class CreateCustomerState extends Equatable {
  final String name;
  final String branchId;
  final String doctorId;
  final String email;
  final String address;
  final String birthday;
  final String gender;
  final String avatar;
  final String phone;
  final String description;
  final List<String> images;
  final CreateCustomerStatus status;

  factory CreateCustomerState.initial() {
    return const CreateCustomerState(
      name: '',
      branchId: '',
      doctorId: '',
      gender: '',
      birthday: '',
      avatar: '',
      email: '',
      phone: '',
      address: '',
      description: '',
      images: [],
      status: CreateCustomerStatus.initial,
    );
  }

  CreateCustomerState clear() {
    return const CreateCustomerState(
      name: '',
      branchId: '',
      doctorId: '',
      gender: '',
      birthday: '',
      avatar: '',
      email: '',
      phone: '',
      address: '',
      description: '',
      images: [],
      status: CreateCustomerStatus.initial,
    );
  }

  CreateCustomerState addImage({required String image}) {
    return CreateCustomerState(
      name: name,
      phone: phone,
      email: email,
      avatar: avatar,
      birthday: birthday,
      branchId: branchId,
      doctorId: doctorId,
      gender: gender,
      address: address,
      description: description,
      status: status,
      images: [...images, image],
    );
  }

  CreateCustomerState copyWith({
    String? name,
    String? branchId,
    String? doctorId,
    String? email,
    String? birthday,
    String? gender,
    String? phone,
    String? avatar,
    String? address,
    String? description,
    CreateCustomerStatus? status,
  }) {
    return CreateCustomerState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      birthday: birthday ?? this.birthday,
      branchId: branchId ?? this.branchId,
      doctorId: doctorId ?? this.doctorId,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      description: description ?? this.description,
      status: status ?? this.status,
      images: images,
    );
  }

  const CreateCustomerState({
    required this.name,
    required this.branchId,
    required this.doctorId,
    required this.birthday,
    required this.avatar,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
    required this.description,
    required this.images,
  });

  @override
  List<Object> get props => [
        name,
        email,
        phone,
        description,
        branchId,
        doctorId,
        birthday,
        avatar,
        gender,
        address,
        status,
        images,
      ];
}
