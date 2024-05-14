import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';

class ListAdminScreen extends StatelessWidget {
  const ListAdminScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "admin",
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
                  Text('LIST ADMIN',
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CreateAdminButton()],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 12,
                          child: FutureBuilder(
                            future: BranchEmployeeRepository()
                                .listBranchEmployees(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final employees = snapshot.data!
                                    .where((element) =>
                                        element.role == "branch-admin")
                                    .toList();

                                return DataTable(
                                  dataRowMaxHeight: 68,
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Admin Name')),
                                    DataColumn(label: Text('Admin Email')),
                                    DataColumn(label: Text('Admin Phone')),
                                    DataColumn(
                                        label: Text('Dental Clinic Name')),
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
                                                    .getBranch(b.branchId),
                                                builder: (context, snapshot2) {
                                                  if (snapshot2
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot2.hasData) {
                                                    final branch =
                                                        snapshot2.data!;
                                                    return Text(
                                                        branch.name ?? '');
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
                                                          '/admin/${b.uid}');
                                                    },
                                                    child: const Text('Detail', style: TextStyle(
                                                      color: Colors.white
                                                    )),
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
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CreateAdminButton extends StatelessWidget {
  const CreateAdminButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-admin");
      },
      icon: Icons.add,
      child: const Text('Add Admin', style: TextStyle(
        color: Colors.white
      )),
    );
  }
}
