import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';

class BranchInformation extends StatelessWidget {
  const BranchInformation({
    super.key,
    required this.branch,
  });

  final Branch branch;

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
                const Text('Dental Clinic Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    )),
                EditBranchButton(id: branch.id)
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(width: 0.5, color: Colors.black54),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      branch.logo != ""
                          ? Image.network(branch.logo ?? "",
                              height: 100, width: 140)
                          : const Row()
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Full Name', value: branch.name ?? "")),
                Expanded(
                    flex: 4,
                    child:
                        ValueField(title: 'Email', value: branch.email ?? "")),
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Phone Number', value: branch.phone ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 12,
                    child: ValueField(
                        title: 'Dental Clinic Address',
                        value: branch.address ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: ValueField(
                        title: 'Description', value: branch.description ?? "")),
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

class EditBranchButton extends StatelessWidget {
  const EditBranchButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
      onPressed: () {
        context.go("/branch/edit/$id");
      },
      child: Text('Edit Dental Clinic',
          style: TextStyle(color: HexColor("#DB1A20"))),
    );
  }
}
