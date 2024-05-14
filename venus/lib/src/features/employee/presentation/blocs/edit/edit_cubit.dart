import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/employee/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/employee.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';

class EditEmployeeCubit extends Cubit<EditEmployeeState> {
  EditEmployeeCubit() : super(EditEmployeeState.initial());

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
    emit(state.copyWith(status: EditEmployeeStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: EditEmployeeStatus.success));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: EditEmployeeStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: EditEmployeeStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: EditEmployeeStatus.initial));
  }

  void roleChanged(String value) {
    emit(state.copyWith(role: value, status: EditEmployeeStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: EditEmployeeStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(
        state.copyWith(description: value, status: EditEmployeeStatus.initial));
  }

  Future<void> editEmployeeSubmitting(Employee employee) async {
    if (state.status == EditEmployeeStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: EditEmployeeStatus.submitting));

    try {
      await EmployeeRepository().updateEmployee(Employee(
          uid: employee.uid,
          email: employee.email,
          name: state.name == "" ? employee.name : state.name,
          phone: state.phone == "" ? employee.phone : state.phone,
          address: state.address == "" ? employee.address : state.address,
          description: state.description == ""
              ? employee.description
              : state.description,
          role: employee.role));

      emit(state.copyWith(status: EditEmployeeStatus.success));
    } catch (_) {}
  }
}
