import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';

class ListDoctorScreen extends StatelessWidget {
  const ListDoctorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "doctor",
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 65,
            color: const Color(0xFFFAFAFA),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LIST DOCTOR',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(height: 24),
                  ListDoctorView(),
                ],
              ),
            )));
  }
}

class ListDoctorView extends StatelessWidget {
  const ListDoctorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 168,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<AppBloc, AppState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      if (state.role == Role.branchAdmin ||
                          state.role == Role.admin) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [CreateDoctorButton()],
                        );
                      }
                      return const Row();
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 12,
                          child: BlocBuilder<AppBloc, AppState>(
                              buildWhen: (previous, current) =>
                                  previous.status != current.status,
                              builder: (context, state) {
                                final role = context.read<AppBloc>().state.role;
                                final uid =
                                    context.read<AppBloc>().state.user.uid;

                                return FutureBuilder(
                                  future: BranchEmployeeRepository()
                                      .listBranchEmployeesWithUser(
                                          role: role, uid: uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      final employees = snapshot.data!
                                          .where((element) =>
                                              element.role == "branch-doctor")
                                          .toList();

                                      return DataTable(
                                        dataRowMaxHeight: 68,
                                        columns: const [
                                          DataColumn(label: Text('ID')),
                                          DataColumn(
                                              label: Text('Doctor Name')),
                                          DataColumn(
                                              label: Text('Doctor Email')),
                                          DataColumn(
                                              label: Text('Doctor Phone')),
                                          DataColumn(
                                              label:
                                                  Text('Dental Clinic Name')),
                                          DataColumn(label: Text('')),
                                        ],
                                        rows: employees
                                            .map((b) => DataRow(cells: [
                                                  DataCell(
                                                    Text(b.uid
                                                        .substring(0, 3)
                                                        .toUpperCase()),
                                                  ),
                                                  DataCell(
                                                    Text(b.name ?? ""),
                                                  ),
                                                  DataCell(
                                                    Text((b.email!.length > 15)
                                                        ? ("${b.email!.substring(0, 15)}...")
                                                        : b.email!),
                                                  ),
                                                  DataCell(
                                                    Text(b.phone ?? ""),
                                                  ),
                                                  DataCell(FutureBuilder(
                                                      future: BranchRepository()
                                                          .getBranch(
                                                              b.branchId),
                                                      builder:
                                                          (context, snapshot2) {
                                                        if (snapshot2
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done &&
                                                            snapshot2.hasData) {
                                                          final branch =
                                                              snapshot2.data!;
                                                          return Text(
                                                              branch.name ??
                                                                  '');
                                                        }
                                                        return const Text("");
                                                      })),
                                                  DataCell(
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        AIButton(
                                                          onPressed: () {
                                                            context.go(
                                                                '/doctor/${b.uid}');
                                                          },
                                                          child: const Text(
                                                              'Detail',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ]))
                                            .toList(),
                                      );
                                    }
                                    return Center(
                                        child: CircularProgressIndicator(
                                            color: HexColor("#DB1A20")));
                                  },
                                );
                              }))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CreateDoctorButton extends StatelessWidget {
  const CreateDoctorButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-doctor");
      },
      icon: Icons.add,
      child: const Text('Add Doctor', style: TextStyle(color: Colors.white)),
    );
  }
}
