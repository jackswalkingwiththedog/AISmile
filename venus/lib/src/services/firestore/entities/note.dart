import 'package:equatable/equatable.dart';

class Note extends Equatable {
  const Note({
    required this.id,
    this.createAt,
    this.customerId,
    this.doctorId,
    this.note,
  });

  final String id;
  final String? customerId;
  final String? doctorId;
  final String? createAt;
  final String? note;

  static const empty = Note(id: '');
  bool get isEmpty => this == Note.empty;
  bool get isNotEmpty => this != Note.empty;

  @override
  List<Object?> get props => [
        id,
        createAt,
        customerId,
        doctorId,
        note,
      ];
}
