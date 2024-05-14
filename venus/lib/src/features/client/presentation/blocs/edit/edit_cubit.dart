import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileState.initial());

  bool isAcceptEdit() {
    if (state.name == "" &&
        state.address == "" &&
        state.birthday == "" &&
        state.file.path == "" &&
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
    emit(state.copyWith(status: EditProfileStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: EditProfileStatus.success));
  }

  void branchIdChanged(String value) {
    emit(state.copyWith(branchId: value, status: EditProfileStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: EditProfileStatus.initial));
  }

  void doctorIdChanged(String value) {
    emit(state.copyWith(doctorId: value, status: EditProfileStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: EditProfileStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: EditProfileStatus.initial));
  }

  void avatarChanged(String value) {
    emit(state.copyWith(avatar: value, status: EditProfileStatus.initial));
  }

  void fileChanged(FileData value) {
    emit(state.copyWith(file: value, status: EditProfileStatus.initial));
  }

  void genderChanged(String value) {
    emit(state.copyWith(gender: value, status: EditProfileStatus.initial));
  }

  void birthdayChanged(String value) {
    emit(state.copyWith(birthday: value, status: EditProfileStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: EditProfileStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: EditProfileStatus.initial));
  }

  Future<void> editProfileSubmitting(Customer customer) async {
    if (state.status == EditProfileStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: EditProfileStatus.submitting));

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
        images: customer.images,
      ));

      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (_) {}
  }
}
