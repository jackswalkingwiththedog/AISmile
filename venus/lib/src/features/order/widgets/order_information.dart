import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/customer/presentation/screens/create_customer.dart';
import 'package:venus/src/features/order/widgets/order_history.dart';
import 'package:venus/src/features/order/widgets/order_images_view.dart';
import 'package:venus/src/services/firestore/entities/order.dart';

class OrderInformation extends StatelessWidget {
  const OrderInformation({
    super.key,
    required this.order,
  });

  final AlignerOrder order;
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Order Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    )),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)))),
                        onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                shadowColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                backgroundColor: Colors.white,
                                child: OrderImagesView(order: order),
                              ),
                            ),
                        child: Text("View Images Scans",
                            style: TextStyle(color: HexColor("#DB1A20"))))
                  ],
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: OrderField(
                        title: 'Print Frequency',
                        value:
                            '${order.printFrequency.toString()} Week / Time')),
                Expanded(
                    flex: 8,
                    child: OrderField(
                        title: 'Description', value: order.description ?? "")),
              ],
            ),
            const Divider(height: 1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 4,
                    child: order.linkDesign == ""
                        ? const OrderField(title: 'Link Design', value: "_")
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              const Text("Link Design",
                                  style: TextStyle(color: Colors.black54)),
                              const SizedBox(height: 8),
                              FileInputView(file: order.linkDesign ?? ""),
                              const SizedBox(height: 16),
                            ],
                          )),
                Expanded(
                    flex: 4,
                    child: order.passCode == ""
                        ? const OrderField(title: "Pass Code", value: "_")
                        : OrderField(
                            title: "Pass Code", value: order.passCode ?? "")),
                BlocBuilder<AppBloc, AppState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    final role = context.read<AppBloc>().state.role;
                    if (role == Role.branchAdmin || role == Role.branchDoctor) {
                      return const Expanded(flex: 4, child: Row());
                    }
                    return Expanded(
                        flex: 4,
                        child: order.fileDesign == ""
                            ? const OrderField(title: 'File Design', value: "_")
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  const Text("File Design",
                                      style: TextStyle(color: Colors.black54)),
                                  const SizedBox(height: 8),
                                  FileInputView(file: order.fileDesign ?? ""),
                                  const SizedBox(height: 16),
                                ],
                              ));
                  },
                )
              ],
            ),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    flex: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tracking Link",
                            style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 8),
                        FileInputView(file: order.tracking ?? "")
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: OrderField(
                        title: 'Total Case',
                        value: order.totalCase.toString())),
                Expanded(
                    flex: 4,
                    child: OrderField(
                        title: 'Case Of Week',
                        value: order.caseInWeek.toString())),
                Expanded(
                    flex: 4,
                    child: OrderField(
                        title: 'Case Printed',
                        value: '${order.casePrinted}/${order.totalCase}')),
              ],
            ),
            const SizedBox(height: 24),
            BlocBuilder<AppBloc, AppState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                final role = context.read<AppBloc>().state.role;
                return role == Role.shipper
                    ? const SizedBox(width: 0)
                    : OrderHistory(order: order);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderField extends StatelessWidget {
  const OrderField({
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
