import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/order/presentation/blocs/create/create_state.dart';
import 'package:venus/src/features/order/utils/user.dart';
import 'package:venus/src/services/firestore/entities/history.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/utils/uuid.dart';
import 'package:intl/intl.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  CreateOrderCubit() : super(CreateOrderState.initial());

  bool isAcceptCreate(String id) {
    if (id != "") {
      if (state.images.isEmpty) {
        return false;
      }
      return true;
    }
    if (state.customerId == "" || state.images.isEmpty) {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: CreateOrderStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: CreateOrderStatus.success));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: CreateOrderStatus.initial));
  }

  void customerIdChanged(String value) {
    emit(state.copyWith(customerId: value, status: CreateOrderStatus.initial));
  }

  void printFrequencyChanged(String value) {
    emit(state.copyWith(
        printFrequency: int.parse(value), status: CreateOrderStatus.initial));
  }

  void imagesScanChanged(String value) {
    emit(state.copyWith(imagesScan: value, status: CreateOrderStatus.initial));
  }

  void addImage({required String image}) {
    emit(state.addImage(image: image));
  }

  Future<void> createOrderSubmitting(
      {required String customerId,
      required Role role,
      required String uid}) async {
    if (state.status == CreateOrderStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateOrderStatus.submitting));

    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      final orderID = generateID();

      await AlignerOrderRepository().createAlignerOrder(AlignerOrder(
          id: orderID,
          customerId: state.customerId == "" ? customerId : state.customerId,
          createAt: formattedDate,
          description: state.description,
          imagesScan: state.imagesScan,
          userSend: '',
          casePrinted: 0,
          passCode: '',
          printFrequency: 1,
          totalCase: 0,
          userReceive: '',
          fileDesign: '',
          designerId: '',
          linkDesign: '',
          printerId: '',
          reviewerId: '',
          shipperId: '',
          addressReceive: '',
          caseInWeek: 0,
          images: state.images,
          timeStart: '',
          tracking: '',
          status: "submit"));

      final user = await getUserInformation(uid: uid, role: role);

      await HistoryRepository().createHistory(History(
          id: generateID(),
          createAt: formattedDate,
          orderId: orderID,
          role: role.toString(),
          procedure: "Create Order",
          uid: uid,
          message: "",
          name: user.name,
          status: "submit"));

      emit(state.copyWith(status: CreateOrderStatus.success));
    } catch (_) {}
  }
}
