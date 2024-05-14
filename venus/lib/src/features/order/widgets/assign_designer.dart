import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/order/presentation/blocs/assign_desginer/assign_designer_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/assign_desginer/assign_designer_state.dart';
import 'package:venus/src/services/firestore/entities/employee.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class AssignDesignerWidget extends StatelessWidget {
  const AssignDesignerWidget({super.key, required this.order});

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
                        children: [
                          StatusAssignDropdown(order: order),
                        ])),
                Expanded(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AssignDesigner(order: order),
                        ])),
                const Expanded(
                    flex: 6,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [NoteInput()]))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NoteInput extends StatelessWidget {
  const NoteInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignDesignerCubit, AssignDesignerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Note'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<AssignDesignerCubit>().noteChanged(value);
                },
                hintText: "Enter note",
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

const List<String> statusList = <String>[
  'Todo',
  'Done',
];

class StatusAssignDropdown extends StatefulWidget {
  const StatusAssignDropdown({super.key, required this.order});
  final AlignerOrder order;
  @override
  State<StatusAssignDropdown> createState() => _StatusAssignDropdownState();
}

class _StatusAssignDropdownState extends State<StatusAssignDropdown> {
  String status = "Select Status";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignDesignerCubit, AssignDesignerState>(
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
              initialSelection:
                  widget.order.status == "assigned" ? "Done" : statusList.first,
              onSelected: (String? value) {
                setState(() {
                  status = value!;
                });
                context
                    .read<AssignDesignerCubit>()
                    .assignStatusChanged(value ?? "");
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

class AssignDesigner extends StatelessWidget {
  const AssignDesigner({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignDesignerCubit, AssignDesignerState>(
      buildWhen: (previous, current) => previous.status != previous.status,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: EmployeeRepository().listEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final designers = snapshot.data!
                      .where((element) => element.role == "designer")
                      .toList();
                  return DesignerAssignDropdown(
                      designers: designers, order: order);
                }
                return const Row();
              },
            ),
          ],
        );
      },
    );
  }
}

class SubmitAssignDesigner extends StatelessWidget {
  const SubmitAssignDesigner(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignDesignerCubit, AssignDesignerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AIButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(context
                      .read<AssignDesignerCubit>()
                      .isAcceptAssign(order: order)
                  ? HexColor("#DB1A20")
                  : Colors.grey)),
          onPressed: () async {
            if (context
                    .read<AssignDesignerCubit>()
                    .isAcceptAssign(order: order) ==
                false) {
              return;
            }
            await context
                .read<AssignDesignerCubit>()
                .assignDesignerSubmiting(order: order, role: role, uid: uid);
            // ignore: use_build_context_synchronously
            context.go('/order/${order.id}');
          },
          icon: Icons.add,
          child: state.status == AssignDesignerStatus.submitting
              ? const ProgressIcon(color: Colors.white)
              : const Text('SUBMIT', style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}

class DesignerAssignDropdown extends StatefulWidget {
  const DesignerAssignDropdown(
      {super.key, required this.designers, required this.order});

  final List<Employee> designers;
  final AlignerOrder order;

  @override
  State<DesignerAssignDropdown> createState() => _DesignerAssignDropdownState();
}

class _DesignerAssignDropdownState extends State<DesignerAssignDropdown> {
  String designerName = "Select Designer";

  @override
  Widget build(BuildContext context) {
    final designers = widget.designers
        .where((element) => element.uid == widget.order.designerId)
        .toList();

    return BlocBuilder<AssignDesignerCubit, AssignDesignerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Designer'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              initialSelection: designers.isNotEmpty ? designers.first.uid : "",
              hintText: designers.isNotEmpty
                  ? designers.first.name
                  : "Select Designer",
              onSelected: (String? value) {
                setState(() {
                  designerName = value!;
                });
                context
                    .read<AssignDesignerCubit>()
                    .designerIdChanged(value ?? "");
              },
              dropdownMenuEntries: widget.designers
                  .map<DropdownMenuEntry<String>>((Employee value) {
                return DropdownMenuEntry<String>(
                    value: value.uid, label: value.name ?? "");
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
