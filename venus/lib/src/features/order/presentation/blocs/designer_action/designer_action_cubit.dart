import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/designer_action/designer_action_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class DesignerActionCubit extends Cubit<DesignerActionState> {
  DesignerActionCubit() : super(DesignerActionState.initial());

  bool isAcceptDesigning(AlignerOrder order) {
    if ((order.status == "assigned" || order.status == "rejected") &&
        state.designerStatus == "In Process") {
      return true;
    }
    return false;
  }

  bool isAcceptDone(AlignerOrder order) {
    if (order.status == "designing" && state.designerStatus == "Done") {
      if (order.fileDesign != "" ||
          order.linkDesign != "" ||
          order.passCode != "") {
        return true;
      }
      if (state.fileDesign == "" ||
          state.linkDesign == "" ||
          state.passCode == "" ||
          state.totalCase == -1) {
        return false;
      }
      return true;
    }
    if (order.status == "rejected" && state.designerStatus == "Done") {
      if (state.fileDesign == "" &&
          state.linkDesign == "" &&
          state.passCode == "" &&
          state.totalCase == -1) {
        return false;
      }
      return true;
    }
    return false;
  }

  void onSubmit() {
    emit(state.copyWith(status: DesignerActionStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: DesignerActionStatus.success));
  }

  Future<void> acceptDesignSubmiting(
      {required AlignerOrder order,
      required String uid,
      required Role role}) async {
    if (state.status == DesignerActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: DesignerActionStatus.submitting));
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
        status: "designing",
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
        procedure: "Designing",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "designing",
      ));

      emit(state.copyWith(status: DesignerActionStatus.success));
    } catch (_) {}
  }

  Future<void> designSubmiting(
      {required AlignerOrder order,
      required String uid,
      required Role role}) async {
    if (state.status == DesignerActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: DesignerActionStatus.submitting));
    try {
      await AlignerOrderRepository().updateAlignerOrder(AlignerOrder(
        id: order.id,
        customerId: order.customerId,
        addressReceive: order.addressReceive,
        // caseInWeek: state.caseOfWeek == -1 ? order.caseInWeek : state.caseOfWeek,
        caseInWeek: 1,
        casePrinted: order.casePrinted,
        createAt: order.createAt,
        description: order.description,
        designerId: order.designerId,
        fileDesign:
            state.fileDesign == "" ? order.fileDesign : state.fileDesign,
        imagesScan: order.imagesScan,
        linkDesign:
            state.linkDesign == "" ? order.linkDesign : state.linkDesign,
        passCode: state.passCode == "" ? order.passCode : state.passCode,
        printFrequency: order.printFrequency,
        printerId: order.printerId,
        reviewerId: order.reviewerId,
        shipperId: order.shipperId,
        status: "waiting review",
        totalCase: state.totalCase == -1 ? order.totalCase : state.totalCase,
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
        procedure: "Done Design",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "waiting review",
      ));

      emit(state.copyWith(status: DesignerActionStatus.success));
    } catch (_) {}
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: DesignerActionStatus.initial));
  }

  void linkDesignChanged(String value) {
    emit(state.copyWith(
        linkDesign: value, status: DesignerActionStatus.initial));
  }

  void passCodeChanged(String value) {
    emit(state.copyWith(passCode: value, status: DesignerActionStatus.initial));
  }

  void totalCaseChanged(String value) {
    emit(state.copyWith(
        totalCase: int.parse(value), status: DesignerActionStatus.initial));
  }

  void caseOfWeekChanged(String value) {
    emit(state.copyWith(
        caseOfWeek: int.parse(value), status: DesignerActionStatus.initial));
  }

  void fileDesignChanged(String value) {
    emit(state.copyWith(
        fileDesign: value, status: DesignerActionStatus.initial));
  }

  void designerStatusChanged(String value) {
    emit(state.copyWith(
        designerStatus: value, status: DesignerActionStatus.initial));
  }
}
