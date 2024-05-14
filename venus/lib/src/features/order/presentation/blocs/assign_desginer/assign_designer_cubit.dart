import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/assign_desginer/assign_designer_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class AssignDesignerCubit extends Cubit<AssignDesignerState> {
  AssignDesignerCubit() : super(AssignDesignerState.initial());

  bool isAcceptAssign({required AlignerOrder order}) {
    if (order.designerId != "" &&
        state.assignStatus != "Todo" &&
        state.designerId != "" &&
        state.designerId != order.designerId) {
      return true;
    }
    if (state.designerId == "" || state.assignStatus != "Done") {
      return false;
    }
    return true;
  }

  void designerIdChanged(String value) {
    emit(state.copyWith(
        designerId: value, status: AssignDesignerStatus.initial));
  }

  void assignStatusChanged(String value) {
    emit(state.copyWith(
        assignStatus: value, status: AssignDesignerStatus.initial));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: AssignDesignerStatus.initial));
  }

  Future<void> assignDesignerSubmiting(
      {required AlignerOrder order,
      required String uid,
      required Role role}) async {
    if (state.status == AssignDesignerStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: AssignDesignerStatus.submitting));
    try {
      await AlignerOrderRepository().updateAlignerOrder(AlignerOrder(
        id: order.id,
        customerId: order.customerId,
        addressReceive: order.addressReceive,
        caseInWeek: order.caseInWeek,
        casePrinted: order.casePrinted,
        createAt: order.createAt,
        description: order.description,
        designerId: state.designerId,
        fileDesign: order.fileDesign,
        imagesScan: order.imagesScan,
        linkDesign: order.linkDesign,
        passCode: order.passCode,
        printFrequency: order.printFrequency,
        printerId: order.printerId,
        reviewerId: order.reviewerId,
        shipperId: order.shipperId,
        status: "assigned",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        images: order.images,
        timeStart: order.timeStart,
        tracking: order.tracking
      ));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure: "Assign Designer",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "assigned",
      ));

      emit(state.copyWith(status: AssignDesignerStatus.success));
    } catch (_) {}
  }
}
