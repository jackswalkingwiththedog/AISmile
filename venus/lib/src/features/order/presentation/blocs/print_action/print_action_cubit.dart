import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/print_action/print_action_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class PrintActionCubit extends Cubit<PrintActionState> {
  PrintActionCubit() : super(PrintActionState.initial());

  bool isAcceptProcess() {
    if (state.printStatus == "In Progress") {
      return true;
    }
    return false;
  }

  bool isAcceptFinish() {
    if (state.printStatus == "Done") {
      return true;
    }
    return false;
  }

  void casePrintedChanged(String value) {
    emit(state.copyWith(
        casePrinted: int.parse(value), status: PrintActionStatus.initial));
  }

  void printStatusChanged(String value) {
    emit(state.copyWith(printStatus: value, status: PrintActionStatus.initial));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: PrintActionStatus.initial));
  }

  Future<void> processSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == PrintActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: PrintActionStatus.submitting));
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
        printerId: uid,
        reviewerId: order.reviewerId,
        shipperId: order.shipperId,
        status: "printing",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        images: order.images,
        timeStart: '',
        tracking: '',
      ));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure: "Printing",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "printing",
      ));

      emit(state.copyWith(status: PrintActionStatus.success));
    } catch (_) {}
  }

  Future<void> finishSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == PrintActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: PrintActionStatus.submitting));
    try {
      await AlignerOrderRepository().updateAlignerOrder(AlignerOrder(
        id: order.id,
        customerId: order.customerId,
        addressReceive: order.addressReceive,
        caseInWeek: order.caseInWeek,
        casePrinted: order.totalCase,
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
        status: "waiting ship",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        images: order.images,
        timeStart: '',
        tracking: '',
      ));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure: "Done Print",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "waiting ship",
      ));

      emit(state.copyWith(status: PrintActionStatus.success));
    } catch (_) {}
  }
}
