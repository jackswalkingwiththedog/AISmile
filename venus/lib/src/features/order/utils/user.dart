import 'package:equatable/equatable.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';

class UserInformation extends Equatable {
  const UserInformation({
    required this.uid,
    this.name,
  });

  final String uid;
  final String? name;

  static const empty = UserInformation(uid: '');
  bool get isEmpty => this == UserInformation.empty;
  bool get isNotEmpty => this != UserInformation.empty;

  @override
  List<Object?> get props => [uid, name];
}

Future<UserInformation> getUserInformation(
    {required String uid, required Role role}) async {
  try {
    if (role == Role.admin ||
        role == Role.designer ||
        role == Role.leadDesigner ||
        role == Role.printer ||
        role == Role.reviewer ||
        role == Role.shipper) {
      final employee = await EmployeeRepository().getEmployee(uid);
      return UserInformation(uid: uid, name: employee.name);
    }
    final employee = await BranchEmployeeRepository().getBranchEmployee(uid);
    return UserInformation(uid: uid, name: employee.name);
  } catch (error) {
    rethrow;  
  }
}
