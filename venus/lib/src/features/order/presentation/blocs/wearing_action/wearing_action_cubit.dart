import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/wearing_action/wearing_action_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class WearingActionCubit extends Cubit<WearingActionState> {
  WearingActionCubit() : super(WearingActionState.initial());

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: WearingActionStatus.initial));
  }

  Future<void> startWearingSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == WearingActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: WearingActionStatus.submitting));
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

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
          shipperId: uid,
          status: "wearing",
          totalCase: order.totalCase,
          userReceive: order.userReceive,
          userSend: order.userSend,
          timeStart: formattedDate,
          images: order.images,
          tracking: order.tracking));

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure: "Start Wearing",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "wearing",
      ));

      emit(state.copyWith(status: WearingActionStatus.success));
    } catch (_) {}
  }

  Future<void> stopWearingSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == WearingActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: WearingActionStatus.submitting));
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
        status: "done",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        timeStart: '',
        tracking: order.tracking,
        images: order.images,
      ));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure: "Stop Wearing",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "done",
      ));

      emit(state.copyWith(status: WearingActionStatus.success));
    } catch (_) {}
  }
}
