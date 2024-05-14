// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/order/presentation/blocs/wearing_action/wearing_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/wearing_action/wearing_action_state.dart';
import 'package:venus/src/services/firestore/entities/order.dart';

class WearingActionWidget extends StatelessWidget {
  const WearingActionWidget({super.key, required this.order});

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
            BlocBuilder<AppBloc, AppState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  final role = context.read<AppBloc>().state.role;
                  final uid = context.read<AppBloc>().state.user.uid;
                  return Row(
                    children: [
                      order.status == "done"
                          ? StartWearingButton(
                              order: order,
                              role: role,
                              uid: uid,
                            )
                          : StopWearingButton(
                              order: order, role: role, uid: uid)
                    ],
                  );
                }),
            const SizedBox(height: 16),
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

class StartWearingButton extends StatelessWidget {
  const StartWearingButton(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WearingActionCubit, WearingActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
              onPressed: () async {
                await context
                    .read<WearingActionCubit>()
                    .startWearingSubmiting(order: order, role: role, uid: uid);
                context.go("/order/${order.id}");
              },
              child: state.status == WearingActionStatus.submitting
                  ? const ProgressIcon(color: Colors.white)
                  : const Text(
                      "Start Wearing",
                      style: TextStyle(color: Colors.white),
                    ));
        });
  }
}

class StopWearingButton extends StatelessWidget {
  const StopWearingButton(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WearingActionCubit, WearingActionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
              style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(132, 32)),
                  backgroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: () async {
                await context
                    .read<WearingActionCubit>()
                    .stopWearingSubmiting(order: order, role: role, uid: uid);
                context.go("/order/${order.id}");
              },
              child: state.status == WearingActionStatus.submitting
                  ? const ProgressIcon(color: Colors.white)
                  : const Text("Stop Wearing"));
        });
  }
}

class NoteInput extends StatelessWidget {
  const NoteInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WearingActionCubit, WearingActionState>(
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
                  context.read<WearingActionCubit>().noteChanged(value);
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
