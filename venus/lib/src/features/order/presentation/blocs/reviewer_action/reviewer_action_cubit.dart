import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/reviewer_action/reviewer_action_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class ReviewerActionCubit extends Cubit<ReviewerActionState> {
  ReviewerActionCubit() : super(ReviewerActionState.initial());
  bool isAcceptReview() {
    if (state.reviewerStatus == "" || state.reviewerStatus == "Todo") {
      return false;
    }
    return true;
  }

  void reviewerStatusChanged(String value) {
    emit(state.copyWith(
        reviewerStatus: value, status: ReviewerActionStatus.initial));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: ReviewerActionStatus.initial));
  }

  Future<void> reviewSubmiting(
      {required AlignerOrder order,
      required String uid,
      required Role role}) async {
    if (state.status == ReviewerActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: ReviewerActionStatus.submitting));
    try {
      await AlignerOrderRepository().updateAlignerOrder(AlignerOrder(
        id: order.id,
        customerId: order.customerId,
        addressReceive: order.addressReceive,
        caseInWeek: order.caseInWeek,
        casePrinted: order.casePrinted,
        createAt: order.createAt,
        description: order.description,
        designerId: order.designerId,
        fileDesign: order.fileDesign,
        imagesScan: order.imagesScan,
        linkDesign: order.linkDesign,
        passCode: order.passCode,
        printFrequency: order.printFrequency,
        printerId: order.printerId,
        reviewerId: uid,
        shipperId: order.shipperId,
        status: state.reviewerStatus == "" || state.reviewerStatus == "Approve"
            ? "waiting approve"
            : "rejected",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        images: order.images,
        timeStart: order.timeStart,
        tracking: order.tracking,
      ));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure:
            state.reviewerStatus == "" || state.reviewerStatus == "Approve"
                ? "Approve Design"
                : "Reject Design",
        uid: uid,
        message: state.note,
        name: user.name,
        status: state.reviewerStatus == "" || state.reviewerStatus == "Approve"
            ? "waiting approve"
            : "rejected",
      ));

      emit(state.copyWith(status: ReviewerActionStatus.success));
    } catch (_) {}
  }
}
