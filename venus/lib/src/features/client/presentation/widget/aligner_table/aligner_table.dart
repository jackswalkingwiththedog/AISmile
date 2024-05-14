import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/client/presentation/widget/aligner_table/aligner.dart';
import 'package:venus/src/services/firestore/entities/order.dart';

class AlignerTable extends StatelessWidget {
  const AlignerTable({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    DateTime timeStart = dateFormat.parse(order.timeStart ?? "");

    Duration duration = DateTime.now().difference(timeStart);

    final aligners = generateListAligners(
            length: (duration.inDays / 7 * (order.caseInWeek ?? 1)).floor(),
            start: timeStart,
            count: order.caseInWeek ?? 1)
        .reversed
        .toList();

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DynamicTable(
            header: Text("LIST ALIGNER",
                style: TextStyle(color: HexColor("#DB1A20"))),
            rowsPerPage: aligners.length > 5 ? 5 : aligners.length,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columnSpacing: 60,
            headingRowHeight: 40,
            showCheckboxColumn: false,
            primary: true,
            rows: List.generate(
                aligners.length,
                (index) => DynamicTableDataRow(
                      index: index,
                      cells: [
                        DynamicTableDataCell(value: (index + 1).toString()),
                        DynamicTableDataCell(value: aligners[index].startDate),
                        DynamicTableDataCell(value: aligners[index].endDate),
                        DynamicTableDataCell(value: aligners[index].status),
                        DynamicTableDataCell(value: aligners[index].remaining),
                      ],
                    )),
            columns: [
              DynamicTableDataColumn(
                  label: const Text("STT"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("Start Wearing"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("End Wearing"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("Status"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("Remaining"),
                  dynamicTableInputType: DynamicTableTextInput()),
            ]));
  }
}

List<Aligner> generateListAligners(
    {required int length, required DateTime start, required int count}) {
  var days = 7 ~/ count;
  var hours = (7 / count - (7 / count).floor()) * 24;
  DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');

  return List.generate(length + 1, (int index) {
    var startDate =
        start.add(Duration(days: days * index, hours: hours.toInt() * index));
    var endDate = start.add(
        Duration(days: days * (index + 1), hours: hours.toInt() * (index + 1)));

    var remainingTime = endDate.difference(DateTime.now());

    return Aligner(
        id: index + 1,
        startDate: dateFormat.format(startDate),
        endDate: dateFormat.format(endDate),
        status: index == length ? "Progress" : "Done",
        remaining: index == length
            ? "${remainingTime.inDays} Days - ${remainingTime.inHours % 24} Hours - ${remainingTime.inMinutes % 60} Minutes"
            : "Done");
  });
}
