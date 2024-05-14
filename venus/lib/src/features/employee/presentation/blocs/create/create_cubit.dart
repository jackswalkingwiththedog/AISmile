import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/employee/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/services/firestore/entities/employee.dart';
import 'package:venus/src/services/firestore/entities/user.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';
import 'package:venus/src/services/firestore/repository/user_repository.dart';

class CreateEmployeeCubit extends Cubit<CreateEmployeeState> {
  CreateEmployeeCubit() : super(CreateEmployeeState.initial());

  bool isAcceptCreate() {
    if (state.name == "" ||
        state.email == "" ||
        state.phone == "" ||
        state.address == "") {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: CreateEmployeeStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: CreateEmployeeStatus.success));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: CreateEmployeeStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: CreateEmployeeStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: CreateEmployeeStatus.initial));
  }

  void roleChanged(String value) {
    emit(state.copyWith(role: value, status: CreateEmployeeStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: CreateEmployeeStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
        description: value, status: CreateEmployeeStatus.initial));
  }

  Future<void> createEmployeeSubmitting({required String role}) async {
    if (state.status == CreateEmployeeStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateEmployeeStatus.submitting));

    try {
      final user =
          await AuthenticationRepository().createUserWithEmailAndPassword(
        email: state.email,
        password: role,
      );

      await UserRepository().createUser(User(
        uid: user.uid,
        role: role,
      ));

      await EmployeeRepository().createEmployee(Employee(
        uid: user.uid,
        email: state.email,
        name: state.name,
        phone: state.phone,
        address: state.address,
        description: state.description,
        role: role,
      ));

      emit(state.copyWith(status: CreateEmployeeStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CreateEmployeeStatus.error));

      rethrow;
    }
  }
}
