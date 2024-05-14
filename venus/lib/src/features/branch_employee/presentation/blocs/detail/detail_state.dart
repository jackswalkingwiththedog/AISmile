import 'package:equatable/equatable.dart';

enum DetailBranchEmployeeStatus { initial, submitting, success, error }

final class DetailBranchEmployeeState extends Equatable {
  final DetailBranchEmployeeStatus status;

  factory DetailBranchEmployeeState.initial() {
    return const DetailBranchEmployeeState(
      status: DetailBranchEmployeeStatus.initial,
    );
  }

  DetailBranchEmployeeState copyWith({
    DetailBranchEmployeeStatus? status,
  }) {
    return DetailBranchEmployeeState(
      status: status ?? this.status,
    );
  }

  const DetailBranchEmployeeState({
    required this.status,
  });

  @override
  List<Object> get props => [
        status,
      ];
}
