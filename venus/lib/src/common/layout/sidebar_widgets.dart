import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/layout/sidebars/admin.dart';
import 'package:venus/src/common/layout/sidebars/branch_admin.dart';
import 'package:venus/src/common/layout/sidebars/branch_doctor.dart';
import 'package:venus/src/common/layout/sidebars/employee.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({
    Key? key,
    required this.page,
  }) : super(key: key);

  final String page;

  @override
  Widget build(BuildContext context) {
    final state = context.select((AppBloc bloc) => bloc.state);
    if (state.role == Role.admin) {
      return AdminSideBar(page: page);
    } else if (state.role == Role.branchAdmin) {
      return BranchAdminSideBar(page: page);
    } else if (state.role == Role.branchDoctor) {
      return BranchDoctorSideBar(page: page);
    } else if (state.role == Role.leadDesigner ||
        state.role == Role.designer ||
        state.role == Role.reviewer ||
        state.role == Role.printer ||
        state.role == Role.shipper) {
      return EmployeeSideBar(page: page);
    }
    return const Row();
  }
}
