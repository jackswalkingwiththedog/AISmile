import 'package:equatable/equatable.dart';

enum DetailOrderStatus { initial, submitting, success, error }

final class DetailOrderState extends Equatable {
  final DetailOrderStatus status;

  factory DetailOrderState.initial() {
    return const DetailOrderState(
      status: DetailOrderStatus.initial,
    );
  }

  DetailOrderState copyWith({
    DetailOrderStatus? status,
  }) {
    return DetailOrderState(
      status: status ?? this.status,
    );
  }

  const DetailOrderState({
    required this.status,
  });

  @override
  List<Object> get props => [
        status,
      ];
}
