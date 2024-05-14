import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';

class EditDoctorScreen extends StatelessWidget {
  const EditDoctorScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "doctor",
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
                  const Text('EDIT DOCTOR',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  EditDoctorView(id: id),
                ],
              ),
            )));
  }
}

class EditDoctorView extends StatelessWidget {
  const EditDoctorView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        listener: (context, state) {
          if (state.status == EditBranchEmployeeStatus.error) {}
        },
        child: FutureBuilder(
          future: BranchEmployeeRepository().getBranchEmployee(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final employee = snapshot.data!;
              return Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 168,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: DoctorNameInput(
                                        value: employee.name ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: DoctorEmailInput(
                                        value: employee.email ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: DoctorPhoneInput(
                                        value: employee.phone ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: DoctorAddressInput(
                                        value: employee.address ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: DoctorDescriptionInput(
                                        value: employee.description ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: DoctorCancelButton(employee: employee),
                                ),
                                const SizedBox(width: 24),
                                SizedBox(
                                  child: DoctorUpdateButton(employee: employee),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class DoctorUpdateButton extends StatelessWidget {
  const DoctorUpdateButton({Key? key, required this.employee})
      : super(key: key);

  final BranchEmployee employee;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<EditBranchEmployeeCubit>().isAcceptEdit()
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<EditBranchEmployeeCubit>().isAcceptEdit() ==
                  false) {
                return;
              }
              await context
                  .read<EditBranchEmployeeCubit>()
                  .editDoctorSubmitting(employee);
              // ignore: use_build_context_synchronously
              context.go('/doctor/${employee.uid}');
            },
            child: state.status == EditBranchEmployeeStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class DoctorCancelButton extends StatelessWidget {
  const DoctorCancelButton({Key? key, required this.employee})
      : super(key: key);

  final BranchEmployee employee;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/doctor/${employee.uid}");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class DoctorNameInput extends StatelessWidget {
  const DoctorNameInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Doctor Name'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().nameChanged(value);
                },
                hintText: value == "" ? "Enter doctor name" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class DoctorEmailInput extends StatelessWidget {
  const DoctorEmailInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Doctor Email'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().emailChanged(value);
                },
                hintText: value == '' ? "Enter doctor email" : value,
                enabled: false,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class DoctorPhoneInput extends StatelessWidget {
  const DoctorPhoneInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Doctor Phone'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().phoneChanged(value);
                },
                hintText: value == "" ? "Enter doctor phone number" : value,
                initialValue: value == "" ? "" : value,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              )
            ],
          );
        });
  }
}

class DoctorAddressInput extends StatelessWidget {
  const DoctorAddressInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Doctor Address'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().addressChanged(value);
                },
                hintText: value == "" ? "Enter doctor address" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class DoctorDescriptionInput extends StatelessWidget {
  const DoctorDescriptionInput({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Description'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context
                      .read<EditBranchEmployeeCubit>()
                      .descriptionChanged(value);
                },
                hintText: value == "" ? "Enter description" : value,
                initialValue: value == "" ? "" : value,
                maxLines: 6,
              )
            ],
          );
        });
  }
}
