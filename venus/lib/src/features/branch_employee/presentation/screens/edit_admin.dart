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

class EditAdminScreen extends StatelessWidget {
  const EditAdminScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "admin",
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
                  const Text('EDIT ADMIN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  EditAdminView(id: id),
                ],
              ),
            )));
  }
}

class EditAdminView extends StatelessWidget {
  const EditAdminView({Key? key, required this.id}) : super(key: key);

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
                                    child: AdminNameInput(
                                        value: employee.name ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: AdminEmailInput(
                                        value: employee.email ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: AdminPhoneInput(
                                        value: employee.phone ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: AdminAddressInput(
                                        value: employee.address ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: AdminDescriptionInput(
                                        value: employee.description ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: AdminCancelButton(employee: employee),
                                ),
                                const SizedBox(width: 24),
                                SizedBox(
                                  child: AdminUpdateButton(employee: employee),
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

class AdminUpdateButton extends StatelessWidget {
  const AdminUpdateButton({Key? key, required this.employee}) : super(key: key);

  final BranchEmployee employee;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchEmployeeCubit, EditBranchEmployeeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                ),
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
                  .editAdminSubmitting(employee);
              // ignore: use_build_context_synchronously
              context.go('/admin/${employee.uid}');
            },
            child: state.status == EditBranchEmployeeStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update', style: TextStyle(
                  color: Colors.white
                )),
          );
        });
  }
}

class AdminCancelButton extends StatelessWidget {
  const AdminCancelButton({Key? key, required this.employee}) : super(key: key);

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
              context.go("/admin/${employee.uid}");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class AdminNameInput extends StatelessWidget {
  const AdminNameInput({Key? key, required this.value}) : super(key: key);

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
              const Text('Admin Name'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().nameChanged(value);
                },
                hintText: value == "" ? "Enter ddmin name" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class AdminEmailInput extends StatelessWidget {
  const AdminEmailInput({Key? key, required this.value}) : super(key: key);

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
              const Text('Admin Email'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().emailChanged(value);
                },
                hintText: value == '' ? "Enter admin email" : value,
                initialValue: value == "" ? "" : value,
                enabled: false,
              )
            ],
          );
        });
  }
}

class AdminPhoneInput extends StatelessWidget {
  const AdminPhoneInput({Key? key, required this.value}) : super(key: key);

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
              const Text('Admin Phone'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().phoneChanged(value);
                },
                hintText: value == "" ? "Enter admin phone number" : value,
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

class AdminAddressInput extends StatelessWidget {
  const AdminAddressInput({Key? key, required this.value}) : super(key: key);

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
              const Text('Admin Address'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchEmployeeCubit>().addressChanged(value);
                },
                hintText: value == "" ? "Enter admin address" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class AdminDescriptionInput extends StatelessWidget {
  const AdminDescriptionInput({Key? key, required this.value})
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
