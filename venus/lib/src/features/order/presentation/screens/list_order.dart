import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';

class ListOrderScreen extends StatelessWidget {
  const ListOrderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "order",
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
                  const Text('LIST ORDER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  BlocBuilder<AppBloc, AppState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        final role = context.read<AppBloc>().state.role;
                        final uid = context.read<AppBloc>().state.user.uid;
                        return ListOrderView(role: role, uid: uid);
                      }),
                ],
              ),
            )));
  }
}

class ListOrderView extends StatelessWidget {
  const ListOrderView({Key? key, required this.role, required this.uid})
      : super(key: key);

  final Role role;
  final String uid;

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
                    children: [
                      (role == Role.admin ||
                              role == Role.branchAdmin ||
                              role == Role.branchDoctor)
                          ? const CreateBranchButton()
                          : const Row()
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AppBloc, AppState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      final role = context.read<AppBloc>().state.role;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 12,
                              child: FutureBuilder(
                                future: AlignerOrderRepository()
                                    .listAlignerOrders(role: role, uid: uid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    final orders =
                                        snapshot.data!.where((element) {
                                      if (role == Role.admin ||
                                          role == Role.leadDesigner) {
                                        return true;
                                      }

                                      if (role == Role.printer) {
                                        if (element.status == "waiting print" ||
                                            (element.status == "printing" ||
                                                    element.status ==
                                                        "receive order" ||
                                                    element.status ==
                                                        "delivering" ||
                                                    element.status == "done" ||
                                                    element.status ==
                                                        "wearing" ||
                                                    element.status ==
                                                        "waiting ship") &&
                                                element.printerId == uid) {
                                          return true;
                                        }
                                        return false;
                                      }

                                      if (role == Role.reviewer) {
                                        if (element.status ==
                                                "waiting review" ||
                                            (element
                                                            .status ==
                                                        "waiting print" ||
                                                    element
                                                            .status ==
                                                        "waiting ship" ||
                                                    element
                                                            .status ==
                                                        "receive order" ||
                                                    element
                                                            .status ==
                                                        "delivering" ||
                                                    element.status == "done" ||
                                                    element.status ==
                                                        "wearing" ||
                                                    element.status ==
                                                        "printing" ||
                                                    element.status ==
                                                        "waiting approve") &&
                                                element.reviewerId == uid) {
                                          return true;
                                        }
                                        return false;
                                      }

                                      if (role == Role.shipper) {
                                        if (element.status == "waiting ship" ||
                                            (element.status ==
                                                        "receive order" ||
                                                    element.status ==
                                                        "delivering" ||
                                                    element.status == "done" ||
                                                    element.status ==
                                                        "wearing") &&
                                                element.shipperId == uid) {
                                          return true;
                                        }
                                        return false;
                                      }

                                      if (role == Role.designer) {
                                        if (uid != element.designerId) {
                                          return false;
                                        }
                                      }
                                      return true;
                                    }).toList();

                                    orders.sort((a, b) {
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
                                      columns: [
                                        const DataColumn(label: Text('ID')),
                                        (role != Role.shipper)
                                            ? const DataColumn(
                                                label: Text('Customer Name'))
                                            : const DataColumn(
                                                label: Text("FROM")),
                                        (role != Role.shipper)
                                            ? const DataColumn(label: Text(''))
                                            : const DataColumn(
                                                label: Text("TO")),
                                        (role != Role.branchDoctor &&
                                                role != Role.shipper)
                                            ? const DataColumn(
                                                label: Text('Doctor Name'))
                                            : const DataColumn(label: Text("")),
                                        const DataColumn(
                                            label: Text('Date Time')),
                                        (role == Role.admin ||
                                                role == Role.leadDesigner)
                                            ? const DataColumn(
                                                label: Text("Designer"))
                                            : const DataColumn(label: Text("")),
                                        const DataColumn(
                                            label: Text('Order Status')),
                                        const DataColumn(label: Text('')),
                                      ],
                                      rows: orders
                                          .map((b) => DataRow(cells: [
                                                DataCell(
                                                  Text(b.id
                                                      .substring(0, 3)
                                                      .toUpperCase()),
                                                ),
                                                DataCell(
                                                  (role != Role.shipper)
                                                      ? FutureBuilder(
                                                          future:
                                                              CustomerRepository()
                                                                  .getCustomer(b
                                                                      .customerId),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot.connectionState ==
                                                                    ConnectionState
                                                                        .done &&
                                                                snapshot
                                                                    .hasData) {
                                                              final customer =
                                                                  snapshot
                                                                      .data!;
                                                              return Text(
                                                                  customer.name ??
                                                                      "");
                                                            }
                                                            return const Text(
                                                                "");
                                                          },
                                                        )
                                                      : const Text("AI SMILE"),
                                                ),
                                                (role != Role.shipper)
                                                    ? const DataCell(Text(""))
                                                    : DataCell(FutureBuilder(
                                                        future:
                                                            CustomerRepository()
                                                                .getCustomer(b
                                                                    .customerId),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot.connectionState ==
                                                                  ConnectionState
                                                                      .done &&
                                                              snapshot
                                                                  .hasData) {
                                                            final customer =
                                                                snapshot.data!;
                                                            return FutureBuilder(
                                                              future: BranchRepository()
                                                                  .getBranch(
                                                                      customer.branchId ??
                                                                          ""),
                                                              builder: (context,
                                                                  snapshot2) {
                                                                if (snapshot2
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .done &&
                                                                    snapshot2
                                                                        .hasData) {
                                                                  final branch =
                                                                      snapshot2
                                                                          .data!;
                                                                  return Text(
                                                                      branch.name ??
                                                                          "");
                                                                }

                                                                return const Text(
                                                                    "");
                                                              },
                                                            );
                                                          }
                                                          return const Text("");
                                                        },
                                                      )),
                                                (role != Role.branchDoctor &&
                                                        role != Role.shipper)
                                                    ? DataCell(
                                                        FutureBuilder(
                                                          future:
                                                              CustomerRepository()
                                                                  .getCustomer(b
                                                                      .customerId),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot.connectionState ==
                                                                    ConnectionState
                                                                        .done &&
                                                                snapshot
                                                                    .hasData) {
                                                              final customer =
                                                                  snapshot
                                                                      .data!;
                                                              return FutureBuilder(
                                                                future: BranchEmployeeRepository()
                                                                    .getBranchEmployee(
                                                                        customer.doctorId ??
                                                                            ""),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot.connectionState ==
                                                                          ConnectionState
                                                                              .done &&
                                                                      snapshot
                                                                          .hasData) {
                                                                    final doctor =
                                                                        snapshot
                                                                            .data!;
                                                                    return Text(
                                                                        doctor.name ??
                                                                            "");
                                                                  }
                                                                  return const Text(
                                                                      "");
                                                                },
                                                              );
                                                            }
                                                            return const Text(
                                                                "");
                                                          },
                                                        ),
                                                      )
                                                    : const DataCell(Text("")),
                                                DataCell(
                                                  Text(b.createAt
                                                          ?.substring(6) ??
                                                      ""),
                                                ),
                                                (role == Role.admin ||
                                                        role ==
                                                            Role.leadDesigner)
                                                    ? DataCell(Row(
                                                        children: [
                                                          b.designerId == ""
                                                              ? const Text("_")
                                                              : DesignerView(
                                                                  order: b),
                                                        ],
                                                      ))
                                                    : const DataCell(Row()),
                                                DataCell(
                                                  Text(
                                                      b.status?.toUpperCase() ??
                                                          ""),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      AIButton(
                                                        onPressed: () {
                                                          context.go(
                                                              '/order/${b.id}');
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
                              ))
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class DesignerView extends StatelessWidget {
  const DesignerView({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EmployeeRepository().listEmployees(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final employees = snapshot.data!
              .where((element) => element.uid == order.designerId)
              .toList();
          return Text(employees[0].name ?? "");
        }
        return const Row();
      },
    );
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
        context.go("/create-order");
      },
      icon: Icons.add,
      child: const Text('Add Order', style: TextStyle(color: Colors.white)),
    );
  }
}
