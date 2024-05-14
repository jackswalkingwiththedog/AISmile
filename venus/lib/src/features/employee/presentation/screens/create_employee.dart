import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/employee/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/employee/presentation/blocs/create/create_state.dart';

class CreateEmployeeScreen extends StatelessWidget {
  const CreateEmployeeScreen({super.key, required this.role});

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
                  Text('CREATE ${role.toUpperCase()}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  CreateEmployeeView(role: role, text: text),
                ],
              ),
            )));
  }
}

class CreateEmployeeView extends StatelessWidget {
  const CreateEmployeeView({Key? key, required this.role, required this.text})
      : super(key: key);

  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateEmployeeCubit, CreateEmployeeState>(
      listener: (context, state) {
        if (state.status == CreateEmployeeStatus.error) {}
      },
      child: Card(
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
                        Expanded(flex: 6, child: EmployeeNameInput(text: text)),
                        const SizedBox(width: 24),
                        Expanded(
                            flex: 6, child: EmployeeEmailInput(text: text)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            flex: 6, child: EmployeePhoneInput(text: text)),
                        const SizedBox(width: 24),
                        Expanded(
                            flex: 6, child: EmployeeAddressInput(text: text)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(flex: 12, child: EmployeeDescriptionInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: EmployeeCancelButton(role: role),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          child: EmployeeCreateButton(role: role),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class EmployeeCreateButton extends StatelessWidget {
  const EmployeeCreateButton({Key? key, required this.role}) : super(key: key);

  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<CreateEmployeeCubit>().isAcceptCreate()
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              try {
                if (context.read<CreateEmployeeCubit>().isAcceptCreate() ==
                    false) {
                  return;
                }
                await context
                    .read<CreateEmployeeCubit>()
                    .createEmployeeSubmitting(role: role);
                // ignore: use_build_context_synchronously
                context.go('/$role');
              } catch (_) {
                return;
              }
            },
            child: state.status == CreateEmployeeStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Create', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class EmployeeCancelButton extends StatelessWidget {
  const EmployeeCancelButton({Key? key, required this.role}) : super(key: key);

  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/$role");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class EmployeeNameInput extends StatelessWidget {
  const EmployeeNameInput({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
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
                  context.read<CreateEmployeeCubit>().nameChanged(value);
                },
                hintText: "Enter $text name",
              )
            ],
          );
        });
  }
}

class EmployeeEmailInput extends StatelessWidget {
  const EmployeeEmailInput({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
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
                  context.read<CreateEmployeeCubit>().emailChanged(value);
                },
                hintText: "Enter $text email",
              )
            ],
          );
        });
  }
}

class EmployeePhoneInput extends StatelessWidget {
  const EmployeePhoneInput({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
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
                  context.read<CreateEmployeeCubit>().phoneChanged(value);
                },
                hintText: "Enter $text phone number",
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
  const EmployeeAddressInput({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
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
                  context.read<CreateEmployeeCubit>().addressChanged(value);
                },
                hintText: "Enter $text address",
              )
            ],
          );
        });
  }
}

class EmployeeDescriptionInput extends StatelessWidget {
  const EmployeeDescriptionInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeCubit, CreateEmployeeState>(
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
                  context.read<CreateEmployeeCubit>().descriptionChanged(value);
                },
                hintText: "Enter description",
                maxLines: 6,
              )
            ],
          );
        });
  }
}
