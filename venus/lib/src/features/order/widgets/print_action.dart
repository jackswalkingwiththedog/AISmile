// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/order/presentation/blocs/print_action/print_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/print_action/print_action_state.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/utils/constants/colors.dart';

class PrintActionWidget extends StatelessWidget {
  const PrintActionWidget({super.key, required this.order});

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
            const SizedBox(height: 16),
            Row(
              children: [
                Text("PRINTED: ${order.casePrinted}/${order.totalCase}")
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [StatusActionDropdown(order: order)])),
                const SizedBox(width: 16),
                // Expanded(
                //     flex: 3,
                //     child: Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           (order.status == "waiting print" ||
                //                   order.casePrinted == order.totalCase)
                //               ? const SizedBox(width: 0)
                //               : const CasePrintedInput()
                //         ])),
                // const SizedBox(width: 16),
                const Expanded(
                    flex: 9,
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
  'Done',
];

class StatusActionDropdown extends StatefulWidget {
  const StatusActionDropdown({super.key, required this.order});
  final AlignerOrder order;
  @override
  State<StatusActionDropdown> createState() => _StatusActionDropdownState();
}

class SubmitPrintAction extends StatelessWidget {
  const SubmitPrintAction(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrintActionCubit, PrintActionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final isAcceptProcess =
            context.read<PrintActionCubit>().isAcceptProcess();

        final isAcceptFinish =
            context.read<PrintActionCubit>().isAcceptFinish();

        return AIButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(
                  (isAcceptProcess || isAcceptFinish)
                      ? HexColor("#DB1A20")
                      : Colors.grey)),
          onPressed: () async {
            if (isAcceptProcess) {
              await context
                  .read<PrintActionCubit>()
                  .processSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }

            if (isAcceptFinish) {
              await context
                  .read<PrintActionCubit>()
                  .finishSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }
          },
          icon: Icons.add,
          child: state.status == PrintActionStatus.submitting
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
    return BlocBuilder<PrintActionCubit, PrintActionState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final orderStatus = widget.order.status;

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
              initialSelection: orderStatus == "waiting print"
                  ? "Todo"
                  : orderStatus == "printing"
                      ? "In Progress"
                      : "Done",
              hintText: orderStatus == "waiting print"
                  ? "Todo"
                  : orderStatus == "printing"
                      ? "In Progress"
                      : "Done",
              onSelected: (String? value) {
                setState(() {
                  status = value!;
                });
                context
                    .read<PrintActionCubit>()
                    .printStatusChanged(value ?? "");
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

class CasePrintedInput extends StatelessWidget {
  const CasePrintedInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrintActionCubit, PrintActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Case Printed'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<PrintActionCubit>().casePrintedChanged(value);
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                hintText: "Enter Case Printed",
              ),
              const SizedBox(height: 24),
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
    return BlocBuilder<PrintActionCubit, PrintActionState>(
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
                  context.read<PrintActionCubit>().noteChanged(value);
                },
                hintText: "Enter note",
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}
