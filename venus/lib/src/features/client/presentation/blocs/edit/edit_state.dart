import 'dart:typed_data';

import 'package:equatable/equatable.dart';

enum EditProfileStatus { initial, submitting, success, error }

class FileData extends Equatable {
  const FileData({
    required this.path,
    this.bytes,
    this.type,
  });

  final String path;
  final Uint8List? bytes;
  final Type? type;

  static const empty = FileData(path: '');
  bool get isEmpty => this == FileData.empty;
  bool get isNotEmpty => this != FileData.empty;

  @override
  List<Object?> get props => [
        path,
        bytes,
        type,
      ];
}

final class EditProfileState extends Equatable {
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
  final FileData file;
  final EditProfileStatus status;

  factory EditProfileState.initial() {
    return const EditProfileState(
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
      file: FileData.empty,
      status: EditProfileStatus.initial,
    );
  }

  EditProfileState copyWith({
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
    FileData? file,
    EditProfileStatus? status,
  }) {
    return EditProfileState(
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
      file: file ?? this.file,
      status: status ?? this.status,
    );
  }

  const EditProfileState({
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
    required this.file,
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
        file,
        status,
      ];
}
