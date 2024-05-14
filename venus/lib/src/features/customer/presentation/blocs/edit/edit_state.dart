import 'package:equatable/equatable.dart';

enum EditCustomerStatus { initial, submitting, success, error }

final class EditCustomerState extends Equatable {
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
  final List<String> removedImages;
  final EditCustomerStatus status;

  factory EditCustomerState.initial() {
    return const EditCustomerState(
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
      removedImages: [],
      images: [],
      status: EditCustomerStatus.initial,
    );
  }

  EditCustomerState addImage({required String image}) {
    return EditCustomerState(
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
      removedImages: removedImages,
      images: [...images, image],
    );
  }

   EditCustomerState removeImage(
      {required String image,
      required List<String> images,
      required List<String> imagesOrder}) {

    final list = [...imagesOrder];
    for (var i = 0; i < images.length; i++) {
      var flag = true;
      for (var j = 0; j < imagesOrder.length; j++) {
        if (images[i] == imagesOrder[j]) {
          flag = false;
          break;
        }
      }
      if (flag) {
        list.add(images[i]);
      }
    }

    list.removeWhere((element) {
      if (element == image) {
        return true;
      }
      for (var i = 0; i < removedImages.length; i++) {
        if (element == removedImages[i]) {
          return true;
        }
      }
      return false;
    });

    return EditCustomerState(
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
      removedImages: [...removedImages, image],
      images: [...list],
    );
  }

  EditCustomerState copyWith({
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
    EditCustomerStatus? status,
  }) {
    return EditCustomerState(
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
      removedImages: removedImages,
      images: images,
    );
  }

  const EditCustomerState(
      {required this.name,
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
      required this.removedImages,
      required this.images});

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
        removedImages,
        images,
      ];
}
