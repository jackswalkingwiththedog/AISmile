import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/employee/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/employee/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/employee.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';

class EditEmployeeScreen extends StatelessWidget {
  const EditEmployeeScreen({super.key, required this.id, required this.role});

  final String id;
  final String role;

  @override
  Widget build(BuildContext context) {
    var text = "";
    if (role == "lead-designer") {
      text = "Lead Designer";
    }
    if (role == "designer") {
      text = "Designer";
    }
    if (role == "reviewer") {
      text = "Reviewer";
    }
    if (role == "printer") {
      text = "Printer";
    }
    if (role == "shipper") {
      text = "Shipper";
    }
    return DashboardLayout(
        page: role,
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
                  Text('EDIT ${role.toUpperCase()}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  EditEmployeeView(id: id, role: role, text: text),
                ],
              ),
            )));
  }
}

class EditEmployeeView extends StatelessWidget {
  const EditEmployeeView(
      {Key? key, required this.id, required this.role, required this.text})
      : super(key: key);

  final String id;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditEmployeeCubit, EditEmployeeState>(
        listener: (context, state) {
          if (state.status == EditEmployeeStatus.error) {}
        },
        child: FutureBuilder(
          future: EmployeeRepository().getEmployee(id),
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
                                    child: EmployeeNameInput(
                                        value: employee.name ?? "",
                                        text: text)),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: EmployeeEmailInput(
                                        value: employee.email ?? "",
                                        text: text)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: EmployeePhoneInput(
                                        value: employee.phone ?? "",
                                        text: text)),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: EmployeeAddressInput(
                                        value: employee.address ?? "",
                                        text: text)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: EmployeeDescriptionInput(
                                        value: employee.description ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: EmployeeCancelButton(
                                      role: role, id: employee.uid),
                                ),
                                const SizedBox(width: 24),
                                SizedBox(
                                  child: EmployeeUpdateButton(
                                      employee: employee, role: role),
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

class EmployeeUpdateButton extends StatelessWidget {
  const EmployeeUpdateButton(
      {Key? key, required this.employee, required this.role})
      : super(key: key);

  final Employee employee;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<EditEmployeeCubit>().isAcceptEdit()
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<EditEmployeeCubit>().isAcceptEdit() == false) {
                return;
              }
              await context
                  .read<EditEmployeeCubit>()
                  .editEmployeeSubmitting(employee);
              // ignore: use_build_context_synchronously
              context.go('/$role/${employee.uid}');
            },
            child: state.status == EditEmployeeStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class EmployeeCancelButton extends StatelessWidget {
  const EmployeeCancelButton({Key? key, required this.role, required this.id})
      : super(key: key);

  final String role;
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/$role/$id");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class EmployeeNameInput extends StatelessWidget {
  const EmployeeNameInput({Key? key, required this.value, required this.text})
      : super(key: key);

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$text Name'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditEmployeeCubit>().nameChanged(value);
                },
                hintText: value == "" ? "Enter $text name" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class EmployeeEmailInput extends StatelessWidget {
  const EmployeeEmailInput({Key? key, required this.value, required this.text})
      : super(key: key);

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$text Email'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditEmployeeCubit>().emailChanged(value);
                },
                hintText: value == '' ? "Enter $text email" : value,
                initialValue: value == "" ? "" : value,
                enabled: false,
              )
            ],
          );
        });
  }
}

class EmployeePhoneInput extends StatelessWidget {
  const EmployeePhoneInput({Key? key, required this.value, required this.text})
      : super(key: key);

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$text Phone'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditEmployeeCubit>().phoneChanged(value);
                },
                hintText: value == "" ? "Enter $text phone number" : value,
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

class EmployeeAddressInput extends StatelessWidget {
  const EmployeeAddressInput(
      {Key? key, required this.value, required this.text})
      : super(key: key);

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$text Address'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditEmployeeCubit>().addressChanged(value);
                },
                hintText: value == "" ? "Enter $text address" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class EmployeeDescriptionInput extends StatelessWidget {
  const EmployeeDescriptionInput({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditEmployeeCubit, EditEmployeeState>(
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
                  context.read<EditEmployeeCubit>().descriptionChanged(value);
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
