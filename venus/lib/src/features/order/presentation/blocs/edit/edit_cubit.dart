import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class EditOrderCubit extends Cubit<EditOrderState> {
  EditOrderCubit() : super(EditOrderState.initial());

  bool isAcceptEdit() {
    if (state.images.isEmpty &&
        state.description == "") {
      return false;
    }
    return true;
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: EditOrderStatus.initial));
  }

  void printFrequencyChanged(String value) {
    emit(state.copyWith(
        printFrequency: int.parse(value), status: EditOrderStatus.initial));
  }

  void imagesScanChanged(String value) {
    emit(state.copyWith(imagesScan: value, status: EditOrderStatus.initial));
  }

  void addImage({required String image}) {
    emit(state.addImage(image: image));
  }

  void removeImage({required String image, required List<String> images, required List<String> imagesOrder}) {
    emit(state.removeImage(image: image, images: images, imagesOrder: imagesOrder));
  }

  void onSubmit() {
    emit(state.copyWith(status: EditOrderStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: EditOrderStatus.success));
  }

  Future<void> updateOrderSubmitting(
      {required AlignerOrder order,
      required Role role,
      required String uid}) async {
    if (state.status == EditOrderStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: EditOrderStatus.submitting));

    try {
      final listImages = state.images.isEmpty
              ? order.images
              : [...state.images];

      await AlignerOrderRepository().updateAlignerOrder(AlignerOrder(
          id: order.id,
          customerId: order.customerId,
          createAt: order.createAt,
          description:
              state.description == "" ? order.description : state.description,
          imagesScan: state.imagesScan,
          userSend: order.userSend,
          casePrinted: order.casePrinted,
          passCode: order.passCode,
          printFrequency: state.printFrequency == 0
              ? order.printFrequency
              : state.printFrequency,
          totalCase: order.totalCase,
          userReceive: order.userReceive,
          fileDesign: order.fileDesign,
          designerId: order.designerId,
          linkDesign: order.linkDesign,
          printerId: order.printerId,
          reviewerId: order.reviewerId,
          shipperId: order.shipperId,
          addressReceive: order.addressReceive,
          caseInWeek: order.caseInWeek,
          images: listImages,
          timeStart: order.timeStart,
          tracking: order.tracking,
          status: order.status));

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
          id: generateID(),
          createAt: formattedDate,
          orderId: order.id,
          role: role.toString(),
          procedure: "Update Order",
          uid: uid,
          message: "",
          name: user.name,
          status: order.status));

      emit(state.copyWith(status: EditOrderStatus.success));
    } catch (_) {}
  }
}
