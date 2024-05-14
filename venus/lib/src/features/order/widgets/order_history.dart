import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/history_repository.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key, required this.order});

  final AlignerOrder order;

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
                    Text('History',
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
                        future: HistoryRepository().listHistorys(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final histories = snapshot.data!
                                .where((element) => element.orderId == order.id)
                                .toList();

                            DateFormat dateFormat =
                                DateFormat('HH:mm dd/MM/yyyy');

                            histories.sort((a, b) {
                              final aTime = dateFormat
                                  .parse(a.createAt ?? '')
                                  .difference(DateTime.now())
                                  .inMinutes;
                              final bTime = dateFormat
                                  .parse(b.createAt ?? '')
                                  .difference(DateTime.now())
                                  .inMinutes;
                              return bTime.compareTo(aTime);
                            });

                            if (histories.isEmpty) {
                              return const Text("_");
                            }

                            return DataTable(
                                dataRowMaxHeight: 72,
                                columns: const [
                                  DataColumn(label: Text('Date Time')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Position')),
                                  DataColumn(label: Text('Procedure')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Message')),
                                ],
                                rows: histories
                                    .map((b) => DataRow(cells: [
                                          DataCell(
                                            Text(b.createAt ?? ""),
                                          ),
                                          DataCell(
                                            Text(b.name == ""
                                                ? "_"
                                                : b.name ?? ""),
                                          ),
                                          DataCell(
                                            Text(b.role!
                                                .substring(5)
                                                .toUpperCase()),
                                          ),
                                          DataCell(
                                            Text(b.procedure ?? ""),
                                          ),
                                          DataCell(
                                            Text(b.status == ""
                                                ? "_"
                                                : b.status ?? ""),
                                          ),
                                          DataCell(SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(b.message == ""
                                                    ? "_"
                                                    : b.message ?? ""),
                                              ],
                                            ),
                                          )),
                                        ]))
                                    .toList());
                          }
                          return Center(
                              child: CircularProgressIndicator(
                                  color: HexColor("#DB1A20")));
                        },
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
