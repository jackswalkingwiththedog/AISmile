import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';

class HistoryCustomer extends StatelessWidget {
  const HistoryCustomer(
      {super.key, required this.customer, required this.role});

  final Customer customer;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('List Order',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        flex: 12,
                        child: FutureBuilder(
                            future: AlignerOrderRepository()
                                .listAlignerOrders(role: Role.admin, uid: ""),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final orders = snapshot.data!
                                    .where((element) =>
                                        element.customerId == customer.uid)
                                    .toList();

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

                                if (orders.isEmpty) {
                                  return const Text("_");
                                }

                                return DataTable(
                                  columns: const [
                                    DataColumn(label: Text('ID')),
                                    DataColumn(label: Text('Customer Name')),
                                    DataColumn(label: Text('Doctor Name')),
                                    DataColumn(label: Text('Date Time')),
                                    DataColumn(label: Text('Order Status')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: orders
                                      .map((b) => DataRow(cells: [
                                            DataCell(
                                              Text(b.id
                                                  .substring(0, 3)
                                                  .toUpperCase()),
                                            ),
                                            DataCell(
                                              FutureBuilder(
                                                future: CustomerRepository()
                                                    .getCustomer(b.customerId),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.hasData) {
                                                    final customer =
                                                        snapshot.data!;
                                                    return Text(
                                                        customer.name ?? "");
                                                  }
                                                  return const Text("");
                                                },
                                              ),
                                            ),
                                            DataCell(
                                              FutureBuilder(
                                                future: CustomerRepository()
                                                    .getCustomer(b.customerId),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.hasData) {
                                                    final customer =
                                                        snapshot.data!;
                                                    return FutureBuilder(
                                                      future: BranchEmployeeRepository()
                                                          .getBranchEmployee(
                                                              customer.doctorId ??
                                                                  ""),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.connectionState ==
                                                                ConnectionState
                                                                    .done &&
                                                            snapshot.hasData) {
                                                          final doctor =
                                                              snapshot.data!;
                                                          return Text(
                                                              doctor.name ??
                                                                  "");
                                                        }
                                                        return const Text("");
                                                      },
                                                    );
                                                  }
                                                  return const Text("");
                                                },
                                              ),
                                            ),
                                            DataCell(
                                              Text(b.createAt ?? ""),
                                            ),
                                            DataCell(
                                              Text(b.status?.toUpperCase() ??
                                                  ""),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  role == Role.customer
                                                      ? const SizedBox(width: 0)
                                                      : AIButton(
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            }))
                  ],
                )
              ],
            )));
  }
}
