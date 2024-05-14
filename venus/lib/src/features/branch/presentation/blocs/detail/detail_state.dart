import 'package:equatable/equatable.dart';

enum DetailBranchStatus { initial, submitting, success, error }

final class DetailBranchState extends Equatable {
  final DetailBranchStatus status;

  factory DetailBranchState.initial() {
    return const DetailBranchState(
      status: DetailBranchStatus.initial,
    );
  }

  DetailBranchState copyWith({
    DetailBranchStatus? status,
  }) {
    return DetailBranchState(
      status: status ?? this.status,
    );
  }

  const DetailBranchState({
    required this.status,
  });

  @override
  List<Object> get props => [
        status,
      ];
}
