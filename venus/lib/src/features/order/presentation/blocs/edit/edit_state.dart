import 'package:equatable/equatable.dart';

enum EditOrderStatus { initial, submitting, success, error }

final class EditOrderState extends Equatable {
  final String imagesScan;
  final String description;
  final int printFrequency;
  final List<String> images;
  final EditOrderStatus status;
  final List<String> removedImages;

  factory EditOrderState.initial() {
    return const EditOrderState(
      imagesScan: '',
      description: '',
      printFrequency: 0,
      images: [],
      removedImages: [],
      status: EditOrderStatus.initial,
    );
  }

  EditOrderState removeImage(
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

    return EditOrderState(
      imagesScan: imagesScan,
      printFrequency: printFrequency,
      description: description,
      status: status,
      removedImages: [...removedImages, image],
      images: [...list],
    );
  }

  EditOrderState addImage({required String image}) {
    return EditOrderState(
      imagesScan: imagesScan,
      printFrequency: printFrequency,
      description: description,
      status: status,
      removedImages: removedImages,
      images: [...images, image],
    );
  }

  EditOrderState copyWith({
    String? createAt,
    String? description,
    String? imagesScan,
    int? printFrequency,
    EditOrderStatus? status,
  }) {
    return EditOrderState(
        imagesScan: imagesScan ?? this.imagesScan,
        printFrequency: printFrequency ?? this.printFrequency,
        description: description ?? this.description,
        status: status ?? this.status,
        removedImages: removedImages,
        images: images);
  }

  const EditOrderState({
    required this.imagesScan,
    required this.status,
    required this.description,
    required this.printFrequency,
    required this.removedImages,
    required this.images,
  });

  @override
  List<Object> get props => [
        imagesScan,
        status,
        removedImages,
        description,
        status,
        printFrequency,
        images,
      ];
}
