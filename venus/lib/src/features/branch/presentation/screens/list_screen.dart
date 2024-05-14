import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';

class ListBranchScreen extends StatelessWidget {
  const ListBranchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "branch",
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
                  Text('LIST DENTAL CLINIC',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(height: 24),
                  ListBranchView(),
                ],
              ),
            )));
  }
}

class ListBranchView extends StatelessWidget {
  const ListBranchView({Key? key}) : super(key: key);

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
                    children: [CreateBranchButton()],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 12,
                          child: FutureBuilder(
                            future: BranchRepository().listBranchs(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final branchs = snapshot.data!.toList();
                                branchs.sort((a, b) {
                                  DateFormat dateFormat =
                                      DateFormat('HH:mm dd/MM/yyyy');
                                  final timeA =
                                      dateFormat.parse(a.createAt ?? "");
                                  final timeB =
                                      dateFormat.parse(b.createAt ?? "");
                                  Duration durationA =
                                      DateTime.now().difference(timeA);
                                  Duration durationB =
                                      DateTime.now().difference(timeB);
                                  return durationA.inMinutes
                                      .compareTo(durationB.inMinutes);
                                });

                                return DataTable(
                                  dataRowMaxHeight: 68,
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Create At')),
                                    DataColumn(
                                        label: Text('Dental Clinic Name')),
                                    DataColumn(
                                        label: Text('Dental Clinic Email')),
                                    DataColumn(
                                        label: Text('Dental Clinic Address')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: branchs
                                      .map((b) => DataRow(cells: [
                                            DataCell(
                                              Text(b.id
                                                  .substring(0, 3)
                                                  .toUpperCase()),
                                            ),
                                            DataCell(
                                              Text(b.createAt?.substring(6) ??
                                                  ""),
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
                                              Text(b.address ?? ""),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  AIButton(
                                                    onPressed: () {
                                                      context.go(
                                                          '/branch/${b.id}');
                                                    },
                                                    child: const Text('Detail',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
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

class CreateBranchButton extends StatelessWidget {
  const CreateBranchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-branch");
      },
      icon: Icons.add,
      child: const Text('Add Dental Clinic',
          style: TextStyle(color: Colors.white)),
    );
  }
}
