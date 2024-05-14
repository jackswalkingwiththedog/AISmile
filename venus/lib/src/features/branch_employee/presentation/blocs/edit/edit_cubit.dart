import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';

class EditBranchEmployeeCubit extends Cubit<EditBranchEmployeeState> {
  EditBranchEmployeeCubit() : super(EditBranchEmployeeState.initial());

  bool isAcceptEdit() {
    if (state.name == "" &&
        state.email == "" &&
        state.phone == "" &&
        state.address == "" &&
        state.description == "") {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: EditBranchEmployeeStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: EditBranchEmployeeStatus.success));
  }

  void nameChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  void branchIdChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  void phoneChanged(String value) {
    emit(
      state.copyWith(
        phone: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  void roleChanged(String value) {
    emit(
      state.copyWith(
        role: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  void addressChanged(String value) {
    emit(
      state.copyWith(
        address: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  void descriptionChanged(String value) {
    emit(
      state.copyWith(
        description: value,
        status: EditBranchEmployeeStatus.initial
      )
    );
  }

  Future<void> editDoctorSubmitting(BranchEmployee doctor) async {
    if (state.status == EditBranchEmployeeStatus.submitting) {
      return;
    }
    emit(
      state.copyWith(
        status: EditBranchEmployeeStatus.submitting
      )
    );

    try {
      await BranchEmployeeRepository().updateBranchEmployee(BranchEmployee(
        uid: doctor.uid,
        email: doctor.email,
        name: state.name == "" ? doctor.name : state.name,
        phone: state.phone == "" ? doctor.phone : state.phone,
        address: state.address == "" ? doctor.address : state.address,
        description: state.description == "" ? doctor.description : state.description,
        role: 'branch-doctor',
        branchId: doctor.branchId,
      ));

      emit(
        state.copyWith(
          status: EditBranchEmployeeStatus.success
        )
      );
      
    } catch(_) {}
  }

  Future<void> editAdminSubmitting(BranchEmployee admin) async {
    if (state.status == EditBranchEmployeeStatus.submitting) {
      return;
    }
    emit(
      state.copyWith(
        status: EditBranchEmployeeStatus.submitting
      )
    );

    try {
      await BranchEmployeeRepository().updateBranchEmployee(BranchEmployee(
        uid: admin.uid,
        email: admin.email,
        name: state.name == "" ? admin.name : state.name,
        phone: state.phone == "" ? admin.phone : state.phone,
        address: state.address == "" ? admin.address : state.address,
        description: state.description == "" ? admin.description : state.description,
        role: 'branch-admin',
        branchId: admin.branchId,
      ));

      emit(
        state.copyWith(
          status: EditBranchEmployeeStatus.success
        )
      );
      
    } catch(_) {}
  }
}