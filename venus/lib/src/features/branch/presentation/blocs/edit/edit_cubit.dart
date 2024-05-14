import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/branch/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';

class EditBranchCubit extends Cubit<EditBranchState> {
  EditBranchCubit() : super(EditBranchState.initial());

  bool isAcceptEdit() {
    if (state.name == "" &&
        state.logo == "" &&
        state.email == "" &&
        state.phone == "" &&
        state.address == "" &&
        state.description == "") {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: EditBranchStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: EditBranchStatus.success));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: EditBranchStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: EditBranchStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: EditBranchStatus.initial));
  }

  void logoChanged(String value) {
    emit(state.copyWith(logo: value, status: EditBranchStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: EditBranchStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: EditBranchStatus.initial));
  }

  Future<void> editBranchSubmitting(Branch branch) async {
    if (state.status == EditBranchStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: EditBranchStatus.submitting));

    try {
      await BranchRepository().updateBranch(Branch(
          id: branch.id,
          name: state.name == "" ? branch.name : state.name,
          logo: state.logo == "" ? branch.logo : state.logo,
          email: state.email == "" ? branch.email : state.email,
          phone: state.phone == "" ? branch.phone : state.phone,
          address: state.address == "" ? branch.address : state.address,
          description: state.description == ""
              ? branch.description
              : state.description,
          createAt: branch.createAt));

      emit(state.copyWith(status: EditBranchStatus.success));
    } catch (_) {}
  }
}
