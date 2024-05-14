import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  const Branch(
      {required this.id,
      this.name,
      this.email,
      this.logo,
      this.address,
      this.phone,
      this.description,
      this.createAt
      });

  final String id;
  final String? name;
  final String? email;
  final String? logo;
  final String? address;
  final String? phone;
  final String? description;
  final String? createAt;

  static const empty = Branch(id: '');
  bool get isEmpty => this == Branch.empty;
  bool get isNotEmpty => this != Branch.empty;

  @override
  List<Object?> get props =>
      [id, name, email, logo, address, phone, description, createAt];
}
