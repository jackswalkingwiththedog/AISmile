import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/customer/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/entities/user.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/user_repository.dart';

class CreateCustomerCubit extends Cubit<CreateCustomerState> {
  CreateCustomerCubit() : super(CreateCustomerState.initial());

  bool isAcceptCreate({required Role role}) {
    if (role == Role.branchAdmin) {
      if (state.name == "" ||
          state.address == "" ||
          state.birthday == "" ||
          state.doctorId == "" ||
          state.email == "" ||
          state.gender == "" ||
          state.phone == "" || state.images.isEmpty) {
        return false;
      }
      return true;
    }

    if (role == Role.branchDoctor) {
      if (state.name == "" ||
          state.address == "" ||
          state.birthday == "" ||
          state.email == "" ||
          state.gender == "" ||
          state.phone == ""|| state.images.isEmpty) {
        return false;
      }
      return true;
    }

    if (state.name == "" ||
        state.address == "" ||
        state.birthday == "" ||
        state.branchId == "" ||
        state.doctorId == "" ||
        state.email == "" ||
        state.gender == "" ||
        state.phone == ""|| state.images.isEmpty) {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: CreateCustomerStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: CreateCustomerStatus.success));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: CreateCustomerStatus.initial));
  }

  void branchIdChanged(String value) {
    emit(state.copyWith(branchId: value, status: CreateCustomerStatus.initial));
  }

  void doctorIdChanged(String value) {
    emit(state.copyWith(doctorId: value, status: CreateCustomerStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: CreateCustomerStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: CreateCustomerStatus.initial));
  }

  void genderChanged(String value) {
    emit(state.copyWith(gender: value, status: CreateCustomerStatus.initial));
  }

  void birthdayChanged(String value) {
    emit(state.copyWith(birthday: value, status: CreateCustomerStatus.initial));
  }

  void addressChanged(String value) {
    emit(state.copyWith(address: value, status: CreateCustomerStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
        description: value, status: CreateCustomerStatus.initial));
  }

  void addImage({required String image}) {
    emit(state.addImage(image: image));
  }

  Future<void> createCustomerSubmitting(
      {required String uid, required Role role}) async {
    if (state.status == CreateCustomerStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateCustomerStatus.submitting));

    try {
      final user =
        await AuthenticationRepository().createUserWithEmailAndPassword(
        email: state.email,
        password: 'customer',
      );

      await UserRepository().createUser(User(
        uid: user.uid,
        role: 'customer',
      ));

      final String branchId;
      final String doctorId;

      if (role == Role.admin) {
        branchId = state.branchId;
        doctorId = state.doctorId;
      } else {
        final employee =
            await BranchEmployeeRepository().getBranchEmployee(uid);
        branchId = employee.branchId;
        doctorId = employee.role == "branch-admin" ? state.doctorId : uid;
      }

      await CustomerRepository().createCustomer(Customer(
        uid: user.uid,
        email: state.email,
        name: state.name,
        phone: state.phone,
        address: state.address,
        description: state.description,
        avatar: state.avatar,
        birthday: state.birthday,
        gender: state.gender,
        branchId: branchId,
        doctorId: doctorId,
        images: state.images,
      ));
      emit(state.copyWith(status: CreateCustomerStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CreateCustomerStatus.error));
      
      rethrow;
    }
  }
}
