// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/customer/presentation/screens/create_customer.dart';
import 'package:venus/src/features/order/presentation/blocs/ship_action/ship_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/ship_action/ship_action_state.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class ShipActionWidget extends StatelessWidget {
  const ShipActionWidget({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("ASSIGN TASK",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),
            FutureBuilder(
              future: CustomerRepository().getCustomer(order.customerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final customer = snapshot.data!;
                  return Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("FROM:"),
                                const SizedBox(width: 8),
                                Text("AISMILE",
                                    style:
                                        TextStyle(color: HexColor("#DB1A20"))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FutureBuilder(
                              future: BranchEmployeeRepository()
                                  .getBranchEmployee(customer.doctorId ?? ""),
                              builder: (context2, snapshot2) {
                                if (snapshot2.connectionState ==
                                        ConnectionState.done &&
                                    snapshot2.hasData) {
                                  final doctor = snapshot2.data!;
                                  return Row(
                                    children: [
                                      const Text("TO: "),
                                      const SizedBox(width: 8),
                                      Text("${doctor.name}",
                                          style: TextStyle(
                                              color: HexColor("#DB1A20"))),
                                    ],
                                  );
                                }
                                return const SizedBox(width: 0);
                              },
                            ),
                            const SizedBox(height: 8),
                            FutureBuilder(
                              future: BranchRepository()
                                  .getBranch(customer.branchId ?? ""),
                              builder: (context2, snapshot2) {
                                if (snapshot2.connectionState ==
                                        ConnectionState.done &&
                                    snapshot2.hasData) {
                                  final branch = snapshot2.data!;
                                  return Row(
                                    children: [
                                      const Text("ADDRESS: "),
                                      const SizedBox(width: 8),
                                      Text("${branch.address}",
                                          style: TextStyle(
                                              color: HexColor("#DB1A20"))),
                                      const SizedBox(width: 24),
                                      const Text("PHONE: "),
                                      const SizedBox(width: 8),
                                      Text("${branch.phone}",
                                          style: TextStyle(
                                              color: HexColor("#DB1A20"))),
                                    ],
                                  );
                                }
                                return const SizedBox(width: 0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [StatusActionDropdown(order: order)])),
                const SizedBox(width: 16),
                Expanded(
                    flex: 9,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [TrackingLink(order: order)])),
              ],
            ),
            const Row(
              children: [
                Expanded(
                    flex: 12,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [NoteInput()])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> statusList = <String>[
  'Todo',
  'In Progress',
  'Delivering',
  'Done',
];

class StatusActionDropdown extends StatefulWidget {
  const StatusActionDropdown({super.key, required this.order});
  final AlignerOrder order;
  @override
  State<StatusActionDropdown> createState() => _StatusActionDropdownState();
}

class SubmitShipAction extends StatelessWidget {
  const SubmitShipAction(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipActionCubit, ShipActionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AIButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(
                  (context.read<ShipActionCubit>().isAcceptShipping(order) ||
                          context.read<ShipActionCubit>().isAcceptDone(order) ||
                          context.read<ShipActionCubit>().isAcceptSave(order))
                      ? HexColor("#DB1A20")
                      : Colors.grey)),
          onPressed: () async {
            if (context.read<ShipActionCubit>().isAcceptShipping(order)) {
              await context
                  .read<ShipActionCubit>()
                  .shipingSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }
            if (context.read<ShipActionCubit>().isAcceptSave(order)) {
              await context
                  .read<ShipActionCubit>()
                  .saveTrackingSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }
            if (context.read<ShipActionCubit>().isAcceptDone(order)) {
              await context
                  .read<ShipActionCubit>()
                  .doneSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }
          },
          icon: Icons.add,
          child: state.status == ShipActionStatus.submitting
              ? const ProgressIcon(color: Colors.white)
              : const Text('SUBMIT', style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}

class _StatusActionDropdownState extends State<StatusActionDropdown> {
  String status = "Select Status";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipActionCubit, ShipActionState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              initialSelection: widget.order.status == "receive order"
                  ? "In Progress"
                  : widget.order.status == "delivering"
                      ? "Delivering"
                      : "Todo",
              hintText: widget.order.status == "receive order"
                  ? "In Progress"
                  : widget.order.status == "delivering"
                      ? "Delivering"
                      : "Todo",
              onSelected: (String? value) {
                setState(() {
                  status = value!;
                });
                context.read<ShipActionCubit>().shipStatusChanged(value ?? "");
              },
              dropdownMenuEntries:
                  statusList.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class TrackingLink extends StatelessWidget {
  const TrackingLink({Key? key, required this.order}) : super(key: key);

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipActionCubit, ShipActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tracking Link'),
              const SizedBox(height: 8),
              (order.status == 'receive order' ||
                      order.status == 'waiting ship')
                  ? AITextFormField(
                      enabled: order.status == 'receive order' &&
                          state.shipStatus == "Delivering",
                      onChanged: (value) {
                        context.read<ShipActionCubit>().trackingChanged(value);
                      },
                      hintText: order.status != 'delivering'
                          ? "Enter tracking link"
                          : order.tracking,
                    )
                  : FileInputView(file: order.tracking ?? ""),
              SizedBox(height: order.tracking != "" ? 52 : 24),
            ],
          );
        });
  }
}

class NoteInput extends StatelessWidget {
  const NoteInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipActionCubit, ShipActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Note'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<ShipActionCubit>().noteChanged(value);
                },
                maxLines: 4,
                hintText: "Enter note",
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}
