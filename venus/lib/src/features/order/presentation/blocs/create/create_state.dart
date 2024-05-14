import 'package:equatable/equatable.dart';

enum CreateOrderStatus { initial, submitting, success, error }

final class CreateOrderState extends Equatable {
  final String customerId;
  final String createAt;
  final String imagesScan;
  final String description;
  final int printFrequency;
  final List<String> images;
  final CreateOrderStatus status;

  factory CreateOrderState.initial() {
    return const CreateOrderState(
      customerId: '',
      createAt: '',
      imagesScan: '',
      description: '',
      printFrequency: 0,
      images: [],
      status: CreateOrderStatus.initial,
    );
  }

  CreateOrderState addImage({required String image}) {
    return CreateOrderState(
      customerId: customerId,
      createAt: createAt,
      imagesScan: imagesScan,
      printFrequency: printFrequency,
      description: description,
      status: status,
      images: [...images, image],
    );
  }

  CreateOrderState copyWith({
    String? customerId,
    String? createAt,
    String? description,
    String? imagesScan,
    int? printFrequency,
    CreateOrderStatus? status,
  }) {
    return CreateOrderState(
      createAt: createAt ?? this.createAt,
      customerId: customerId ?? this.customerId,
      imagesScan: imagesScan ?? this.imagesScan,
      printFrequency: printFrequency ?? this.printFrequency,
      description: description ?? this.description,
      status: status ?? this.status,
      images: images
    );
  }

  const CreateOrderState(
      {required this.customerId,
      required this.createAt,
      required this.imagesScan,
      required this.status,
      required this.description,
      required this.printFrequency,
      required this.images});

  @override
  List<Object> get props => [
        customerId,
        createAt,
        imagesScan,
        status,
        description,
        status,
        printFrequency,
        images,
      ];
}
