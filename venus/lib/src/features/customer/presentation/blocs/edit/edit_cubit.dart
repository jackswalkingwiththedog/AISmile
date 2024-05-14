import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/customer/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class EditCustomerCubit extends Cubit<EditCustomerState> {
  EditCustomerCubit() : super(EditCustomerState.initial());
  
  bool isAcceptEdit({required Role role}) {
    if (role == Role.branchAdmin) {
      if (state.name == "" &&
          state.address == "" &&
          state.birthday == "" &&
          state.description == "" &&
          state.images.isEmpty &&
          state.doctorId == "" &&
          state.email == "" &&
          state.gender == "" &&
          state.phone == "") {
        return false;
      }
    }

    if (role == Role.branchDoctor) {
      if (state.name == "" &&
          state.address == "" &&
          state.images.isEmpty &&
          state.birthday == "" &&
          state.description == "" &&
          state.email == "" &&
          state.gender == "" &&
          state.phone == "") {
        return false;
      }
    }

    if (state.name == "" &&
        state.address == "" &&
        state.birthday == "" &&
        state.images.isEmpty &&
        state.branchId == "" &&
        state.description == "" &&
        state.doctorId == "" &&
        state.email == "" &&
        state.gender == "" &&
        state.phone == "") {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: EditCustomerStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: EditCustomerStatus.success));
  }

  void branchIdChanged(String value) {
    emit(state.copyWith(branchId: value, status: EditCustomerStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: EditCustomerStatus.initial));
  }

  void doctorIdChanged(String value) {
    emit(state.copyWith(doctorId: value, status: EditCustomerStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: EditCustomerStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: EditCustomerStatus.initial));
  }

  void avatarChanged(String value) {
    emit(state.copyWith(avatar: value, status: EditCustomerStatus.initial));
  }

  void genderChanged(String value) {
    emit(state.copyWith(gender: value, status: EditCustomerStatus.initial));
  }

  void birthdayChanged(String value) {
    emit(state.copyWith(birthday: value, status: EditCustomerStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: EditCustomerStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(
        state.copyWith(description: value, status: EditCustomerStatus.initial));
  }

  void addImage({required String image}) {
    emit(state.addImage(image: image));
  }

  void removeImage({required String image, required List<String> images, required List<String> imagesOrder}) {
    emit(state.removeImage(image: image, images: images, imagesOrder: imagesOrder));
  }

  Future<void> editCustomerSubmitting(Customer customer) async {
    if (state.status == EditCustomerStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: EditCustomerStatus.submitting));

    try {
      await CustomerRepository().updateCustomer(Customer(
        uid: customer.uid,
        email: customer.email,
        name: state.name == "" ? customer.name : state.name,
        phone: state.phone == "" ? customer.phone : state.phone,
        address: state.address == "" ? customer.address : state.address,
        description:
            state.description == "" ? customer.description : state.description,
        avatar: state.avatar == "" ? customer.avatar : state.avatar,
        birthday: state.birthday == "" ? customer.birthday : state.birthday,
        gender: state.gender == "" ? customer.gender : state.gender,
        branchId: state.branchId == "" ? customer.branchId : state.branchId,
        doctorId: state.doctorId == "" ? customer.doctorId : state.doctorId,
        images: state.images.isEmpty ? customer.images : [...state.images],
      ));

      emit(state.copyWith(status: EditCustomerStatus.success));
    } catch (_) {}
  }
}
