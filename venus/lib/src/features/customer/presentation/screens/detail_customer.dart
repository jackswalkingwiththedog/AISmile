// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/client/presentation/widget/wearing_table/wearing_table.dart';
import 'package:venus/src/features/customer/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/customer/presentation/blocs/detail/detail_state.dart';
import 'package:venus/src/features/customer/presentation/widgets/customer_information.dart';
import 'package:venus/src/features/customer/presentation/widgets/history.dart';
import 'package:venus/src/features/customer/presentation/widgets/note_table.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/note_repository.dart';
import 'package:venus/src/services/firestore/repository/wearing_repository.dart';

class DetailCustomerScreen extends StatelessWidget {
  const DetailCustomerScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "customer",
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 65,
            color: const Color(0xFFFAFAFA),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DETAIL CUSTOMER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  BlocBuilder<AppBloc, AppState>(builder: (context, state) {
                    final uid = context.read<AppBloc>().state.user.uid;
                    final role = context.read<AppBloc>().state.role;
                    return DetailCustomerView(
                        id: id, doctorId: uid, role: role);
                  }),
                ],
              ),
            )));
  }
}

class DetailCustomerView extends StatelessWidget {
  const DetailCustomerView(
      {Key? key, required this.id, required this.doctorId, required this.role})
      : super(key: key);

  final String id;
  final String doctorId;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailCustomerCubit, DetailCustomerState>(
        listener: (context, state) {
          if (state.status == DetailCustomerStatus.error) {}
        },
        child: FutureBuilder(
          future: CustomerRepository().getCustomer(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final customer = snapshot.data!;
              return Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 168,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlocBuilder<AppBloc, AppState>(
                                buildWhen: (previous, current) =>
                                    previous != current,
                                builder: (context, state) {
                                  final role =
                                      context.read<AppBloc>().state.role;
                                  if (role == Role.branchDoctor) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CreateOrderButton(id: id),
                                        const SizedBox(width: 24),
                                        CreateAppointmentButton(id: id),
                                      ],
                                    );
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CreateOrderButton(id: id),
                                    ],
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomerInformation(customer: customer),
                        const SizedBox(height: 24),
                        HistoryCustomer(customer: customer, role: role),
                        const SizedBox(height: 24),
                        FutureBuilder(
                          future: WearingRepository().listWearings(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final wearings = snapshot.data!
                                  .where((element) =>
                                      element.customerId == customer.uid)
                                  .toList();

                              wearings.sort((a, b) {
                                DateFormat dateFormat =
                                    DateFormat('HH:mm dd/MM/yyyy');
                                final timeA =
                                    dateFormat.parse(a.createTime ?? "");
                                final timeB =
                                    dateFormat.parse(b.createTime ?? "");
                                Duration durationA =
                                    DateTime.now().difference(timeA);
                                Duration durationB =
                                    DateTime.now().difference(timeB);
                                return durationA.inMinutes
                                    .compareTo(durationB.inMinutes);
                              });

                              if (wearings.isEmpty) {
                                return const Row();
                              }

                              return WearingTable(listWearing: wearings);
                            }

                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                        const SizedBox(height: 24),
                        role == Role.branchDoctor
                            ? BlocBuilder<DetailCustomerCubit,
                                    DetailCustomerState>(
                                buildWhen: (previous, current) =>
                                    previous != current,
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Expanded(
                                          flex: 12,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 24),
                                                  const Text("Doctor Note: ",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      )),
                                                  const SizedBox(width: 16),
                                                  OutlinedButton(
                                                      style: ButtonStyle(
                                                          shape: MaterialStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4)))),
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                DetailCustomerCubit>()
                                                            .openChanged(
                                                                !state.open);
                                                      },
                                                      child: Text(state.open
                                                          ? "Close"
                                                          : "Create note")),
                                                  const SizedBox(width: 16),
                                                  state.open
                                                      ? AIButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(state
                                                                              .note ==
                                                                          ""
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .blue),
                                                              fixedSize:
                                                                  const MaterialStatePropertyAll(
                                                                      Size(86,
                                                                          28))),
                                                          onPressed: () async {
                                                            if (state.note ==
                                                                "") {
                                                              return;
                                                            }
                                                            await context
                                                                .read<
                                                                    DetailCustomerCubit>()
                                                                .createNoteSubmitting(
                                                                    customerId:
                                                                        id,
                                                                    doctorId:
                                                                        doctorId);
                                                            context
                                                                .read<
                                                                    DetailCustomerCubit>()
                                                                .openChanged(
                                                                    !state
                                                                        .open);
                                                          },
                                                          child: state.status ==
                                                                  DetailCustomerStatus
                                                                      .submitting
                                                              ? const ProgressIcon(
                                                                  color: Colors
                                                                      .white)
                                                              : const Text(
                                                                  "Save"))
                                                      : const SizedBox(
                                                          width: 0),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: state.open ? 24 : 0),
                                              state.open
                                                  ? Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 24),
                                                        Expanded(
                                                            flex: 12,
                                                            child:
                                                                AITextFormField(
                                                              onChanged:
                                                                  (value) {
                                                                context
                                                                    .read<
                                                                        DetailCustomerCubit>()
                                                                    .noteChanged(
                                                                        value);
                                                              },
                                                              hintText:
                                                                  "Enter note",
                                                              maxLines: 4,
                                                            )),
                                                        const SizedBox(
                                                            width: 24),
                                                      ],
                                                    )
                                                  : const SizedBox(width: 0),
                                            ],
                                          )),
                                    ],
                                  );
                                })
                            : const Row(),
                        const SizedBox(height: 24),
                        role == Role.branchDoctor
                            ? BlocBuilder<DetailCustomerCubit,
                                DetailCustomerState>(
                                buildWhen: (previous, current) =>
                                    previous.status ==
                                        DetailCustomerStatus.submitting &&
                                    current.status ==
                                        DetailCustomerStatus.success,
                                builder: (context, state) {
                                  return FutureBuilder(
                                    future: NoteRepository().listNotes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        final notes = snapshot.data!
                                            .where((element) =>
                                                element.customerId ==
                                                    customer.uid &&
                                                element.doctorId == doctorId)
                                            .toList();

                                        notes.sort((a, b) {
                                          DateFormat dateFormat =
                                              DateFormat('HH:mm dd/MM/yyyy');
                                          final timeA = dateFormat
                                              .parse(a.createAt ?? "");
                                          final timeB = dateFormat
                                              .parse(b.createAt ?? "");
                                          Duration durationA =
                                              DateTime.now().difference(timeA);
                                          Duration durationB =
                                              DateTime.now().difference(timeB);
                                          return durationA.inMinutes
                                              .compareTo(durationB.inMinutes);
                                        });

                                        if (notes.isEmpty) {
                                          return const Row();
                                        }

                                        return NoteTable(listNotes: notes);
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  );
                                },
                              )
                            : const Row(),
                      ])),
                    ),
                  ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class CreateOrderButton extends StatelessWidget {
  const CreateOrderButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/customer/create-order/$id");
      },
      icon: Icons.add,
      child: const Text('Create Order', style: TextStyle(color: Colors.white)),
    );
  }
}

class CreateAppointmentButton extends StatelessWidget {
  const CreateAppointmentButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/appointment/$id");
      },
      icon: Icons.add,
      child: const Text('Create Appointment',
          style: TextStyle(color: Colors.white)),
    );
  }
}
