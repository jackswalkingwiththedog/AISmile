import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/branch/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class CreateBranchCubit extends Cubit<CreateBranchState> {
  CreateBranchCubit() : super(CreateBranchState.initial());

  bool isAcceptCreate() {
    if (state.name == "" ||
        state.logo == "" ||
        state.email == "" ||
        state.phone == "" ||
        state.address == "") {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: CreateBranchStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: CreateBranchStatus.success));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: CreateBranchStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: CreateBranchStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: CreateBranchStatus.initial));
  }

  void logoChanged(String value) {
    emit(state.copyWith(logo: value, status: CreateBranchStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: CreateBranchStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(
        state.copyWith(description: value, status: CreateBranchStatus.initial));
  }

  Future<void> createBranchSubmitting() async {
    if (state.status == CreateBranchStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateBranchStatus.submitting));

    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);


      await BranchRepository().createBranch(Branch(
          id: generateID(),
          name: state.name,
          logo: state.logo,
          email: state.email,
          phone: state.phone,
          address: state.address,
          description: state.description,
          createAt: formattedDate));

      emit(state.copyWith(status: CreateBranchStatus.success));
    } catch (_) {}
  }
}
