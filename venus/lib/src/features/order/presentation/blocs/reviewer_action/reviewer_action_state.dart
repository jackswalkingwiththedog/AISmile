import 'package:equatable/equatable.dart';

enum ReviewerActionStatus { initial, submitting, success, error }

final class ReviewerActionState extends Equatable {
  final String reviewerStatus;
  final String note;
  final ReviewerActionStatus status;

  factory ReviewerActionState.initial() {
    return const ReviewerActionState(
      reviewerStatus: '',
      note: "",
      status: ReviewerActionStatus.initial,
    );
  }

  ReviewerActionState copyWith({
    String? reviewerStatus,
    String? note,
    ReviewerActionStatus? status,
  }) {
    return ReviewerActionState(
      reviewerStatus: reviewerStatus ?? this.reviewerStatus,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const ReviewerActionState({
    required this.reviewerStatus,
    required this.status,
    required this.note,
  });

  @override
  List<Object> get props => [
        reviewerStatus,
        status,
        note,
      ];
}
