import 'package:equatable/equatable.dart';

enum DesignerActionStatus { initial, submitting, success, error }

final class DesignerActionState extends Equatable {
  final String linkDesign;
  final String passCode;
  final int totalCase;
  final int caseOfWeek;
  final String fileDesign;
  final String designerStatus;
  final String note;
  final DesignerActionStatus status;

  factory DesignerActionState.initial() {
    return const DesignerActionState(
      linkDesign: '',
      passCode: '',
      totalCase: -1,
      caseOfWeek: -1,
      fileDesign: '',
      designerStatus: '',
      note: "",
      status: DesignerActionStatus.initial,
    );
  }

  DesignerActionState copyWith({
    String? linkDesign,
    String? passCode,
    int? totalCase,
    int? caseOfWeek,
    String? fileDesign,
    String? designerStatus,
    String? note,
    DesignerActionStatus? status,
  }) {
    return DesignerActionState(
      caseOfWeek: caseOfWeek ?? this.caseOfWeek,
      fileDesign: fileDesign ?? this.fileDesign,
      linkDesign: linkDesign ?? this.linkDesign,
      passCode: passCode ?? this.passCode,
      totalCase: totalCase ?? this.totalCase,
      designerStatus: designerStatus ?? this.designerStatus,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const DesignerActionState({
    required this.linkDesign,
    required this.passCode,
    required this.totalCase,
    required this.caseOfWeek,
    required this.fileDesign,
    required this.designerStatus,
    required this.status,
    required this.note,
  });

  @override
  List<Object> get props => [
        linkDesign,
        passCode,
        totalCase,
        caseOfWeek,
        fileDesign,
        designerStatus,
        status,
        note,
      ];
}
