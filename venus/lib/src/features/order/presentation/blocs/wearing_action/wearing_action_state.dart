import 'package:equatable/equatable.dart';

enum WearingActionStatus { initial, submitting, success, error }

final class WearingActionState extends Equatable {
  final String note;
  final WearingActionStatus status;

  factory WearingActionState.initial() {
    return const WearingActionState(
      note: "",
      status: WearingActionStatus.initial,
    );
  }

  WearingActionState copyWith({
    String? shipStatus,
    String? note,
    WearingActionStatus? status,
  }) {
    return WearingActionState(
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const WearingActionState({
    required this.status,
    required this.note,
  });

  @override
  List<Object> get props => [
        status,
        note,
      ];
}
