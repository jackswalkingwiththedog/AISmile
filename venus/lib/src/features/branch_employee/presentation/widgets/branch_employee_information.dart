import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';

class BranchEmployeeInformation extends StatelessWidget {
  const BranchEmployeeInformation({
    super.key,
    required this.employee,
    required this.title,
    required this.role,
  });

  final BranchEmployee employee;
  final String title;
  final String role;

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
                EditBranchEmployeeButton(id: employee.uid, role: role)
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
                    flex: 4,
                    child: FutureBuilder(
                        future: BranchRepository().getBranch(employee.branchId),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                                  ConnectionState.done &&
                              snapshot2.hasData) {
                            final branch = snapshot2.data!;
                            return ValueField(
                                title: 'Dental Clinic', value: branch.name ?? "");
                          }
                          return const Text("");
                        })),
                Expanded(
                    flex: 8,
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

class EditBranchEmployeeButton extends StatelessWidget {
  const EditBranchEmployeeButton(
      {Key? key, required this.id, required this.role})
      : super(key: key);

  final String id;
  final String role;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
              )
            ),
      onPressed: () {
        final r = (role == "admin") ? "admin" : "doctor";
        context.go("/$r/edit/$id");
      },
      child: Text(role == "admin" ? "Edit Admin" : "Edit Doctor", style: TextStyle(
        color: HexColor("#DB1A20"),
      )),
    );
  }
}
