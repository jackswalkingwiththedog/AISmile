import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';

class ListEmployeeScreen extends StatelessWidget {
  const ListEmployeeScreen({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: role,
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 65,
            color: const Color(0xFFFAFAFA),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LIST ${role.toUpperCase()}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  ListEmployeeView(role: role),
                ],
              ),
            )));
  }
}

class ListEmployeeView extends StatelessWidget {
  const ListEmployeeView({Key? key, required this.role}) : super(key: key);

  final String role;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CreateEmployeeButton(role: role)],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 12,
                          child: FutureBuilder(
                            future: EmployeeRepository().listEmployees(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final employees = snapshot.data!
                                    .where((element) => element.role == role)
                                    .toList();

                                var text = "";
                                if (role == "lead-designer") {
                                  text = "Lead Designer";
                                }
                                if (role == "designer") {
                                  text = "Designer";
                                }
                                if (role == "reviewer") {
                                  text = "Reviewer";
                                }
                                if (role == "printer") {
                                  text = "Printer";
                                }
                                if (role == "shipper") {
                                  text = "Shipper";
                                }

                                return DataTable(
                                  dataRowMaxHeight: 68,
                                  columns: [
                                    const DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('$text Name')),
                                    DataColumn(label: Text('$text Email')),
                                    DataColumn(label: Text('$text Phone')),
                                    const DataColumn(label: Text('Role')),
                                    const DataColumn(label: Text('')),
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
                                            DataCell(
                                              Text(b.role?.toUpperCase() ?? ""),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  AIButton(
                                                    onPressed: () {
                                                      context.go(
                                                          '/$role/${b.uid}');
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

class CreateEmployeeButton extends StatelessWidget {
  const CreateEmployeeButton({Key? key, required this.role}) : super(key: key);

  final String role;

  @override
  Widget build(BuildContext context) {
    var text = "";
    if (role == "lead-designer") {
      text = "Lead Designer";
    }
    if (role == "designer") {
      text = "Designer";
    }
    if (role == "reviewer") {
      text = "Reviewer";
    }
    if (role == "printer") {
      text = "Printer";
    }
    if (role == "shipper") {
      text = "Shipper";
    }

    return AIButton(
      onPressed: () {
        context.go("/create-$role");
      },
      icon: Icons.add,
      child: Text('Add $text', style: const TextStyle(
        color: Colors.white
      )),
    );
  }
}
