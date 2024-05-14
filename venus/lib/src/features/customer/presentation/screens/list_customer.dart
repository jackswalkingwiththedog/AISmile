import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class ListCustomerScreen extends StatelessWidget {
  const ListCustomerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "customer",
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
                  Text('LIST CUSTOMER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(height: 24),
                  ListCustomerView(),
                ],
              ),
            )));
  }
}

class ListCustomerView extends StatelessWidget {
  const ListCustomerView({Key? key}) : super(key: key);

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
                    children: [CreateCustomerButton()],
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
                            final uid = context.read<AppBloc>().state.user.uid;

                            return FutureBuilder(
                              future: CustomerRepository()
                                  .listCustomersWithUser(role: role, uid: uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  final employees = snapshot.data!.toList();

                                  return DataTable(
                                    dataRowMaxHeight: 68,
                                    columns: const [
                                      DataColumn(label: Text('ID')),
                                      DataColumn(label: Text('Customer Name')),
                                      DataColumn(label: Text('Customer Email')),
                                      DataColumn(label: Text('Customer Phone')),
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
                                                      .getBranch(
                                                          b.branchId ?? ""),
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
                                                            '/customer/${b.uid}');
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
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CreateCustomerButton extends StatelessWidget {
  const CreateCustomerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-customer");
      },
      icon: Icons.add,
      child: const Text('Add Customer', style: TextStyle(color: Colors.white)),
    );
  }
}
