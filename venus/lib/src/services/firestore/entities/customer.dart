import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  const Customer({
    required this.uid,
    this.branchId,
    this.doctorId,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthday,
    this.address,
    this.avatar,
    this.description,
    this.images,
  });

  final String uid;
  final String? branchId;
  final String? doctorId;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? birthday;
  final String? address;
  final String? avatar;
  final String? description;
  final List<String>? images;

  static const empty = Customer(uid: '');
  bool get isEmpty => this == Customer.empty;
  bool get isNotEmpty => this != Customer.empty;

  @override
  List<Object?> get props => [
        uid,
        branchId,
        doctorId,
        name,
        email,
        phone,
        gender,
        birthday,
        address,
        avatar,
        description,
        images,
      ];
}
