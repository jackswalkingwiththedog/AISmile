import 'package:equatable/equatable.dart';

enum PrintActionStatus { initial, submitting, success, error }

final class PrintActionState extends Equatable {
  final int casePrinted;
  final String printStatus;
  final String note;
  final PrintActionStatus status;

  factory PrintActionState.initial() {
    return const PrintActionState(
      casePrinted: 0,
      printStatus: '',
      note: "",
      status: PrintActionStatus.initial,
    );
  }

  PrintActionState copyWith({
    int? casePrinted,
    String? printStatus,
    String? note,
    PrintActionStatus? status,
  }) {
    return PrintActionState(
      casePrinted: casePrinted ?? this.casePrinted,
      printStatus: printStatus ?? this.printStatus,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const PrintActionState({
    required this.casePrinted,
    required this.printStatus,
    required this.status,
    required this.note,
  });

  @override
  List<Object> get props => [
        casePrinted,
        printStatus,
        status,
        note,
      ];
}
