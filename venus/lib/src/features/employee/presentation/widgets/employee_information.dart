import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/services/firestore/entities/employee.dart';

class EmployeeInformation extends StatelessWidget {
  const EmployeeInformation(
      {super.key,
      required this.employee,
      required this.title,
      required this.role,
      required this.text});

  final Employee employee;
  final String title;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    )),
                EditEmployeeButton(id: employee.uid, role: role, text: text)
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Full Name', value: employee.name ?? "")),
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Email', value: employee.email ?? "")),
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Phone Number', value: employee.phone ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 12,
                    child: ValueField(
                        title: 'Address', value: employee.address ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Description',
                        value: employee.description ?? "")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ValueField extends StatelessWidget {
  const ValueField({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Text(value),
        const SizedBox(height: 16),
      ],
    );
  }
}

class EditEmployeeButton extends StatelessWidget {
  const EditEmployeeButton(
      {Key? key, required this.id, required this.role, required this.text})
      : super(key: key);

  final String id;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
      onPressed: () {
        context.go("/$role/edit/$id");
      },
      child: Text("Edit $text", style: TextStyle(color: HexColor("#DB1A20"))),
    );
  }
}
