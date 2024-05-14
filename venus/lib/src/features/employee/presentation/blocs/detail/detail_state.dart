import 'package:equatable/equatable.dart';

enum DetailEmployeeStatus { initial, submitting, success, error }

final class DetailEmployeeState extends Equatable {
  final DetailEmployeeStatus status;

  factory DetailEmployeeState.initial() {
    return const DetailEmployeeState(
      status: DetailEmployeeStatus.initial,
    );
  }

  DetailEmployeeState copyWith({
    DetailEmployeeStatus? status,
  }) {
    return DetailEmployeeState(
      status: status ?? this.status,
    );
  }

  const DetailEmployeeState({
    required this.status,
  });

  @override
  List<Object> get props => [
        status,
      ];
}
