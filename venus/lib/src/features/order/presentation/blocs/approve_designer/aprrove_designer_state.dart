import 'package:equatable/equatable.dart';

enum ApproveActionStatus { initial, submitting, success, error }

final class ApproveActionState extends Equatable {
  final String approveStatus;
  final String note;
  final ApproveActionStatus status;

  factory ApproveActionState.initial() {
    return const ApproveActionState(
      approveStatus: '',
      note: "",
      status: ApproveActionStatus.initial,
    );
  }

  ApproveActionState copyWith({
    String? approveStatus,
    String? note,
    ApproveActionStatus? status,
  }) {
    return ApproveActionState(
      approveStatus: approveStatus ?? this.approveStatus,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const ApproveActionState({
    required this.approveStatus,
    required this.status,
    required this.note,
  });

  @override
  List<Object> get props => [
        approveStatus,
        status,
        note,
      ];
}
