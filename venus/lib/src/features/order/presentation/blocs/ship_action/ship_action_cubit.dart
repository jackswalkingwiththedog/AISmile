import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/ship_action/ship_action_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class ShipActionCubit extends Cubit<ShipActionState> {
  ShipActionCubit() : super(ShipActionState.initial());

  bool isAcceptShipping(AlignerOrder order) {
    if (state.shipStatus == "In Progress" && order.status == 'waiting ship') {
      return true;
    }
    return false;
  }

  bool isAcceptDone(AlignerOrder order) {
    if (state.shipStatus == "Done" && order.status == 'delivering') {
      return true;
    }
    return false;
  }

  bool isAcceptSave(AlignerOrder order) {
    if (state.shipStatus == "Delivering" && order.status == 'receive order' && state.tracking != "") {
      return true;
    }
    return false;
  }

  void shipStatusChanged(String value) {
    emit(state.copyWith(shipStatus: value, status: ShipActionStatus.initial));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: ShipActionStatus.initial));
  }

  void trackingChanged(String value) {
    emit(state.copyWith(tracking: value, status: ShipActionStatus.initial));
  }

  Future<void> saveTrackingSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == ShipActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: ShipActionStatus.submitting));
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
        shipperId: uid,
        status: "delivering",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        timeStart: '',
        tracking: state.tracking,
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
        procedure: "Delivering",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "delivering", 
      ));

      emit(state.copyWith(status: ShipActionStatus.success));
    } catch (_) {}
  }

  Future<void> shipingSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == ShipActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: ShipActionStatus.submitting));
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
        shipperId: uid,
        status: "receive order",
        totalCase: order.totalCase,
        userReceive: order.userReceive,
        userSend: order.userSend,
        tracking: order.tracking,
        timeStart: '',
        images: order.images
      ));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
        id: generateID(),
        createAt: formattedDate,
        orderId: order.id,
        role: role.toString(),
        procedure: "Receive Order",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "receive order",
      ));

      emit(state.copyWith(status: ShipActionStatus.success));
    } catch (_) {}
  }

  Future<void> doneSubmiting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == ShipActionStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: ShipActionStatus.submitting));
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
        images: order.images,
        timeStart: '',
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
        procedure: "Done",
        uid: uid,
        message: state.note,
        name: user.name,
        status: "done",
      ));

      emit(state.copyWith(status: ShipActionStatus.success));
    } catch (_) {}
  }
}
