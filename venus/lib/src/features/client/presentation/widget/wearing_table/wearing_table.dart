import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/features/client/presentation/widget/wearing_view/wearing_view.dart';
import 'package:venus/src/services/firestore/entities/wearing.dart';

class WearingTable extends StatelessWidget {
  const WearingTable({super.key, required this.listWearing});

  final List<Wearing> listWearing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DynamicTable(
            header: Text("LIST WEARING",
                style: TextStyle(color: HexColor("#DB1A20"))),
            rowsPerPage: listWearing.length > 5 ? 5 : listWearing.length,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columnSpacing: 60,
            headingRowHeight: 40,
            showCheckboxColumn: false,
            primary: true,
            rows: List.generate(
                listWearing.length,
                (index) => DynamicTableDataRow(
                      index: index,
                      cells: [
                        DynamicTableDataCell(value: (index + 1).toString()),
                        DynamicTableDataCell(
                            value: listWearing[index].createTime),
                        DynamicTableDataCell(
                            value: listWearing[index].note == ""
                                ? "--"
                                : listWearing[index].note),
                        DynamicTableDataCell(
                            value: "VIEW IMAGE",
                            onTap: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    shadowColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    child: WearingView(
                                        wearing: listWearing[index]),
                                  ),
                                ))
                      ],
                    )),
            columns: [
              DynamicTableDataColumn(
                  label: const Text("STT"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("Create Time"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text("Note"),
                  dynamicTableInputType: DynamicTableTextInput()),
              DynamicTableDataColumn(
                  label: const Text(""),
                  dynamicTableInputType: DynamicTableTextInput()),
            ]));
  }
}
