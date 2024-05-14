import 'package:equatable/equatable.dart';

enum DetailCustomerStatus { initial, submitting, success, error }

final class DetailCustomerState extends Equatable {
  final bool open;
  final String note;
  final DetailCustomerStatus status;

  factory DetailCustomerState.initial() {
    return const DetailCustomerState(
      open: false,
      note: '',
      status: DetailCustomerStatus.initial,
    );
  }

  DetailCustomerState copyWith({
    bool? open,
    String? note,
    DetailCustomerStatus? status,
  }) {
    return DetailCustomerState(
      open: open ?? this.open,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const DetailCustomerState({
    required this.open,
    required this.note,
    required this.status,
  });

  @override
  List<Object> get props => [
        open,
        note,
        status,
      ];
}
