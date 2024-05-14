import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.customer,
  });

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Profile Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    )),
                EditCustomerButton(id: customer.uid)
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Full Name', value: customer.name ?? "")),
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Gender', value: customer.gender ?? "")),
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Birth Day', value: customer.birthday ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Email', value: customer.email ?? "")),
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Phone Number', value: customer.phone ?? "")),
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Address', value: customer.address ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: CustomerField(
                        title: 'Description',
                        value: customer.description ?? "")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerField extends StatelessWidget {
  const CustomerField({
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

class EditCustomerButton extends StatelessWidget {
  const EditCustomerButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
              )
            ),
      onPressed: () {
        context.go("/profile/edit");
      },
      child: const Text('Edit Profile'),
    );
  }
}
