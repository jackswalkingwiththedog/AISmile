import 'package:equatable/equatable.dart';

class Aligner extends Equatable {
  const Aligner({
    required this.id,
    this.startDate,
    this.endDate,
    this.status,
    this.remaining,
  });

  final int id;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? remaining;

  static const empty = Aligner(id: 0);
  bool get isEmpty => this == Aligner.empty;
  bool get isNotEmpty => this != Aligner.empty;

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        status,
        remaining,
      ];
}
