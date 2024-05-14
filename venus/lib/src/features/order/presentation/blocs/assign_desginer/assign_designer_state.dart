import 'package:equatable/equatable.dart';

enum AssignDesignerStatus { initial, submitting, success, error }

final class AssignDesignerState extends Equatable {
  final String assignStatus;
  final String note;
  final String designerId;
  final AssignDesignerStatus status;

  factory AssignDesignerState.initial() {
    return const AssignDesignerState(
      assignStatus: "",
      note: "",
      designerId: '',
      status: AssignDesignerStatus.initial,
    );
  }

  AssignDesignerState copyWith({
    String? designerId,
    String? assignStatus,
    String? note,
    AssignDesignerStatus? status,
  }) {
    return AssignDesignerState(
      assignStatus: assignStatus ?? this.assignStatus,
      note: note ?? this.note,
      designerId: designerId ?? this.designerId,
      status: status ?? this.status,
    );
  }

  const AssignDesignerState(
      {required this.status, required this.designerId, required this.note,required this.assignStatus});

  @override
  List<Object> get props => [status, designerId, assignStatus, note];
}
