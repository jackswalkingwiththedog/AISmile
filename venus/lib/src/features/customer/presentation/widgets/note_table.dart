import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/services/firestore/entities/note.dart';

class NoteTable extends StatelessWidget {
  const NoteTable({super.key, required this.listNotes});

  final List<Note> listNotes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DynamicTable(
            header:
              Text("LIST NOTE", style: TextStyle(color: HexColor("#DB1A20"))),
            rowsPerPage: listNotes.length > 5 ? 5 : listNotes.length,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columnSpacing: 60,
            headingRowHeight: 40,
            showCheckboxColumn: false,
            primary: true,
            rows: List.generate(
                listNotes.length,
                (index) => DynamicTableDataRow(
                      index: index,
                      cells: [
                        DynamicTableDataCell(value: (index + 1).toString()),
                        DynamicTableDataCell(value: listNotes[index].createAt),
                        DynamicTableDataCell(
                            value: listNotes[index].note ?? ""),
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
            ]));
  }
}
