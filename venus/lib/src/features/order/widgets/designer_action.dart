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
import 'package:venus/src/features/customer/presentation/screens/create_customer.dart';
import 'package:venus/src/features/order/presentation/blocs/designer_action/designer_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/designer_action/designer_action_state.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class DesignerActionWidget extends StatelessWidget {
  const DesignerActionWidget({super.key, required this.order});

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
                Expanded(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [StatusActionDropdown(order: order)])),
                const SizedBox(width: 16),
                Expanded(
                    flex: 6,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [LinkDesignInput(order: order)])),
                const SizedBox(width: 16),
                Expanded(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [PasscodeInput(order: order)])),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [TotalCaseInput(order: order)])),
                const SizedBox(width: 16),
                // Expanded(
                //     flex: 3,
                //     child: Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [CaseOfWeekInput(order: order)])),
                // const SizedBox(width: 16),
                Expanded(
                    flex: 9,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [OrderFileDesignInput(order: order)])),
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
            )
          ],
        ),
      ),
    );
  }
}

class OrderFileDesignInput extends StatelessWidget {
  const OrderFileDesignInput({Key? key, required this.order}) : super(key: key);

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
        buildWhen: (previous, current) =>
            previous.fileDesign != current.fileDesign,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('File Design'),
              const SizedBox(height: 8),
              Row(
                children: [
                  FileButtonInput(
                    onPressed: () async {
                      if (order.status == "assigned") {
                        return;
                      }
                      context.read<DesignerActionCubit>().onSubmit();
                      final logo = await handleUploadFile(
                          filename: generateID(), folder: "file/order");
                      context
                          .read<DesignerActionCubit>()
                          .fileDesignChanged(logo);
                      context.read<DesignerActionCubit>().onSuccess();
                    },
                  ),
                  const SizedBox(width: 24),
                  (state.fileDesign != "" || order.fileDesign != "")
                      ? FileInputView(
                          file: state.fileDesign != ""
                              ? state.fileDesign
                              : order.fileDesign ?? "")
                      : const Row(),
                ],
              ),
              const SizedBox(height: 48),
            ],
          );
        });
  }
}

class FileButtonInput extends StatelessWidget {
  const FileButtonInput({
    Key? key,
    this.onPressed,
    this.file,
  }) : super(key: key);

  final void Function()? onPressed;
  final String? file;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: onPressed,
            child: state.status != DesignerActionStatus.submitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload,
                        size: 24,
                        color: HexColor("#DB1A20"),
                      ),
                      Text('Upload',
                          style: TextStyle(color: HexColor("#DB1A20"))),
                    ],
                  )
                : ProgressIcon(color: HexColor("#DB1A20")));
      },
    );
  }
}

class SubmitDesignerAction extends StatelessWidget {
  const SubmitDesignerAction(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AIButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(context
                          .read<DesignerActionCubit>()
                          .isAcceptDesigning(order) ||
                      context.read<DesignerActionCubit>().isAcceptDone(order)
                  ? HexColor("#DB1A20")
                  : Colors.grey)),
          onPressed: () async {
            if (context.read<DesignerActionCubit>().isAcceptDesigning(order)) {
              await context
                  .read<DesignerActionCubit>()
                  .acceptDesignSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }

            if (context.read<DesignerActionCubit>().isAcceptDone(order)) {
              await context
                  .read<DesignerActionCubit>()
                  .designSubmiting(order: order, role: role, uid: uid);
              context.go("/order/${order.id}");
            }
          },
          icon: Icons.add,
          child: state.status == DesignerActionStatus.submitting
              ? const ProgressIcon(color: Colors.white)
              : const Text('SUBMIT', style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}

const List<String> statusList = <String>[
  'Todo',
  'In Process',
  'Done',
];

class StatusActionDropdown extends StatefulWidget {
  const StatusActionDropdown({super.key, required this.order});
  final AlignerOrder order;
  @override
  State<StatusActionDropdown> createState() => _StatusActionDropdownState();
}

class _StatusActionDropdownState extends State<StatusActionDropdown> {
  String status = "Select Status";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
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
              initialSelection: orderStatus == "assigned"
                  ? "Todo"
                  : orderStatus == "designing"
                      ? "In Process"
                      : orderStatus == "rejected"
                          ? "Todo"
                          : "Done",
              hintText: orderStatus == "assigned"
                  ? "Todo"
                  : orderStatus == "designing"
                      ? "In Process"
                      : orderStatus == "rejected"
                          ? "Todo"
                          : "Done",
              onSelected: (String? value) {
                setState(() {
                  status = value!;
                });
                context
                    .read<DesignerActionCubit>()
                    .designerStatusChanged(value ?? "");
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

class NoteInput extends StatelessWidget {
  const NoteInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
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
                  context.read<DesignerActionCubit>().noteChanged(value);
                },
                hintText: "Enter note",
                maxLines: 3,
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

class LinkDesignInput extends StatelessWidget {
  const LinkDesignInput({
    Key? key,
    required this.order,
  }) : super(key: key);

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Link Design'),
              const SizedBox(height: 8),
              AITextFormField(
                enabled:
                    order.status != "assigned" && order.status != "rejected",
                onChanged: (value) {
                  context.read<DesignerActionCubit>().linkDesignChanged(value);
                },
                initialValue: order.linkDesign == "" ? "" : order.linkDesign,
                hintText: order.linkDesign == ""
                    ? "Enter Link Design"
                    : order.linkDesign,
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

class PasscodeInput extends StatelessWidget {
  const PasscodeInput({
    Key? key,
    required this.order,
  }) : super(key: key);

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Passcode'),
              const SizedBox(height: 8),
              AITextFormField(
                enabled:
                    order.status != "assigned" && order.status != "rejected",
                onChanged: (value) {
                  context.read<DesignerActionCubit>().passCodeChanged(value);
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                initialValue: order.passCode == "" ? "" : order.passCode,
                hintText:
                    order.passCode == "" ? "Enter Passcode" : order.passCode,
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

class TotalCaseInput extends StatelessWidget {
  const TotalCaseInput({Key? key, required this.order}) : super(key: key);

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Case'),
              const SizedBox(height: 8),
              AITextFormField(
                enabled:
                    order.status != "assigned" && order.status != "rejected",
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  context.read<DesignerActionCubit>().totalCaseChanged(value);
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                initialValue:
                    order.totalCase == 0 ? "" : order.totalCase.toString(),
                hintText: order.totalCase == 0
                    ? "Enter Total Case"
                    : order.totalCase.toString(),
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

class CaseOfWeekInput extends StatelessWidget {
  const CaseOfWeekInput({Key? key, required this.order}) : super(key: key);

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerActionCubit, DesignerActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Case Of Week'),
              const SizedBox(height: 8),
              AITextFormField(
                enabled:
                    order.status != "assigned" && order.status != "rejected",
                onChanged: (value) {
                  context.read<DesignerActionCubit>().caseOfWeekChanged(value);
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                initialValue:
                    order.caseInWeek == 0 ? "" : order.caseInWeek.toString(),
                hintText: order.caseInWeek == 0
                    ? "Enter Case Of Week"
                    : order.caseInWeek.toString(),
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}
