import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/services/firestore/entities/user.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/user_repository.dart';

class CreateBranchEmployeeCubit extends Cubit<CreateBranchEmployeeState> {
  CreateBranchEmployeeCubit() : super(CreateBranchEmployeeState.initial());

  bool isAcceptCreate({required String id, required Role role}) {
    if (id == "" && role != Role.branchAdmin) {
      if (state.name == "" ||
          state.email == "" ||
          state.phone == "" ||
          state.branchId == "" ||
          state.address == "") {
        return false;
      }
      return true;
    }

    if (state.name == "" ||
        state.email == "" ||
        state.phone == "" ||
        state.address == "") {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: CreateBranchEmployeeStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: CreateBranchEmployeeStatus.success));
  }

  void nameChanged(String value) {
    emit(state.copyWith(
        name: value, status: CreateBranchEmployeeStatus.initial));
  }

  void branchIdChanged(String value) {
    emit(state.copyWith(
        branchId: value, status: CreateBranchEmployeeStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(
        email: value, status: CreateBranchEmployeeStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(
        phone: value, status: CreateBranchEmployeeStatus.initial));
  }

  void roleChanged(String value) {
    emit(state.copyWith(
        role: value, status: CreateBranchEmployeeStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(
        address: value, status: CreateBranchEmployeeStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
        description: value, status: CreateBranchEmployeeStatus.initial));
  }

  Future<void> createBranchDoctorSubmitting(String id) async {
    if (state.status == CreateBranchEmployeeStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateBranchEmployeeStatus.submitting));

    try {
      final user =
          await AuthenticationRepository().createUserWithEmailAndPassword(
        email: state.email,
        password: 'branch-doctor',
      );

      await UserRepository().createUser(User(
        uid: user.uid,
        role: 'branch-doctor',
      ));

      if (id == "") {
        emit(state.copyWith(status: CreateBranchEmployeeStatus.success));
        return;
      }

      await BranchEmployeeRepository().createBranchEmployee(BranchEmployee(
          uid: user.uid,
          email: state.email,
          branchId: id,
          name: state.name,
          phone: state.phone,
          address: state.address,
          description: state.description,
          role: 'branch-doctor'));

      emit(state.copyWith(status: CreateBranchEmployeeStatus.success));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createBranchAdminSubmitting(String id) async {
    if (state.status == CreateBranchEmployeeStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateBranchEmployeeStatus.submitting));

    try {
      final user =
          await AuthenticationRepository().createUserWithEmailAndPassword(
        email: state.email,
        password: 'branch-admin',
      );

      await UserRepository().createUser(User(
        uid: user.uid,
        role: 'branch-admin',
      ));

      await BranchEmployeeRepository().createBranchEmployee(BranchEmployee(
          uid: user.uid,
          email: state.email,
          branchId: id,
          name: state.name,
          phone: state.phone,
          address: state.address,
          description: state.description,
          role: 'branch-admin'));

      emit(state.copyWith(status: CreateBranchEmployeeStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CreateBranchEmployeeStatus.error));
      
      rethrow;
    }
  }
}
