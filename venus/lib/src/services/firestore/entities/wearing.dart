import 'package:equatable/equatable.dart';

class Wearing extends Equatable {
  const Wearing({
    required this.id,
    this.customerId,
    this.createTime,
    this.images,
    this.note,
  });

  final String id;
  final String? customerId;
  final String? createTime;
  final List<String>? images;
  final String? note;

  static const empty = Wearing(id: '');
  bool get isEmpty => this == Wearing.empty;
  bool get isNotEmpty => this != Wearing.empty;

  @override
  List<Object?> get props => [
        id,
        customerId,
        createTime,
        images,
        note,
      ];
}
