import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/approve_designer/aprrove_designer_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class ApproveActionCubit extends Cubit<ApproveActionState> {
  ApproveActionCubit() : super(ApproveActionState.initial());
  bool isAcceptApprove() {
    return true;
  }

  void approveStatusChanged(String value) {
    emit(state.copyWith(
        approveStatus: value, status: ApproveActionStatus.initial));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: ApproveActionStatus.initial));
  }

  Future<void> approveSubmiting(
      {required AlignerOrder order,
      required String uid,
      required Role role}) async {
    if (state.status == ApproveActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: ApproveActionStatus.submitting));
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
        reviewerId: order.reviewerId,
        shipperId: order.shipperId,
        status: state.approveStatus == "" || state.approveStatus == "Approve"
            ? "waiting print"
            : "designing",
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
        procedure: state.approveStatus == "" || state.approveStatus == "Approve"
            ? "Approve Design"
            : "Reject Design",
        uid: uid,
        message: state.note,
        name: user.name,
        status: state.approveStatus == "" || state.approveStatus == "Approve"
            ? "waiting print"
            : "designing",
      ));

      emit(state.copyWith(status: ApproveActionStatus.success));
    } catch (_) {}
  }
}
