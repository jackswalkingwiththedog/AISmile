import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class CreateAdminScreen extends StatelessWidget {
  const CreateAdminScreen({super.key, required this.id});

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
                  const Text('CREATE ADMIN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  CreateAdminView(id: id),
                ],
              ),
            )));
  }
}

class CreateAdminView extends StatelessWidget {
  const CreateAdminView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
      listener: (context, state) {
        if (state.status == CreateBranchEmployeeStatus.error) {}
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
                    id == ""
                        ? BlocBuilder<AppBloc, AppState>(
                            buildWhen: (previous, current) =>
                                previous.status != current.status,
                            builder: (context, state) {
                              final role = context.read<AppBloc>().state.role;
                              if (role != Role.admin) {
                                return const Row();
                              }
                              return FutureBuilder(
                                future: BranchRepository().listBranchs(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    final branchs = snapshot.data!.toList();

                                    return Row(
                                      children: [
                                        BranchAssignDropdown(branchs: branchs)
                                      ],
                                    );
                                  }
                                  return const Row();
                                },
                              );
                            },
                          )
                        : const Row(),
                    const Row(
                      children: [
                        Expanded(flex: 6, child: AdminNameInput()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: AdminEmailInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(flex: 6, child: AdminPhoneInput()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: AdminAddressInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(flex: 12, child: AdminDescriptionInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          child: AdminCancelButton(),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          child: AdminCreateButton(id: id),
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

class BranchAssignDropdown extends StatefulWidget {
  const BranchAssignDropdown({super.key, required this.branchs});

  final List<Branch> branchs;

  @override
  State<BranchAssignDropdown> createState() => _BranchAssignDropdownState();
}

class _BranchAssignDropdownState extends State<BranchAssignDropdown> {
  String doctorName = "Select Dental Clinic";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Dental Clinic'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              initialSelection: "",
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              onSelected: (String? value) {
                setState(() {
                  doctorName = value!;
                });
                context
                    .read<CreateBranchEmployeeCubit>()
                    .branchIdChanged(value ?? "");
              },
              dropdownMenuEntries:
                  widget.branchs.map<DropdownMenuEntry<String>>((Branch value) {
                return DropdownMenuEntry<String>(
                    value: value.id, label: value.name ?? "");
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class AdminCreateButton extends StatelessWidget {
  const AdminCreateButton({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(context
                        .read<CreateBranchEmployeeCubit>()
                        .isAcceptCreate(id: id, role: Role.admin)
                    ? HexColor("#DB1A20")
                    : Colors.grey)),
            onPressed: () async {
              try {
                if (context
                        .read<CreateBranchEmployeeCubit>()
                        .isAcceptCreate(id: id, role: Role.admin) ==
                    false) {
                  return;
                }
                await context
                    .read<CreateBranchEmployeeCubit>()
                    .createBranchAdminSubmitting(state.branchId);
                // ignore: use_build_context_synchronously
                context.go('/admin');
              } catch (_) {
                return;
              }
            },
            child: state.status == CreateBranchEmployeeStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Create', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class AdminCancelButton extends StatelessWidget {
  const AdminCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/admin");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class AdminNameInput extends StatelessWidget {
  const AdminNameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
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
                  context.read<CreateBranchEmployeeCubit>().nameChanged(value);
                },
                hintText: "Enter admin name",
              )
            ],
          );
        });
  }
}

class AdminEmailInput extends StatelessWidget {
  const AdminEmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
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
                  context.read<CreateBranchEmployeeCubit>().emailChanged(value);
                },
                hintText: "Enter admin email",
              )
            ],
          );
        });
  }
}

class AdminPhoneInput extends StatelessWidget {
  const AdminPhoneInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
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
                  context.read<CreateBranchEmployeeCubit>().phoneChanged(value);
                },
                hintText: "Enter admin phone number",
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
  const AdminAddressInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
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
                  context
                      .read<CreateBranchEmployeeCubit>()
                      .addressChanged(value);
                },
                hintText: "Enter admin address",
              )
            ],
          );
        });
  }
}

class AdminDescriptionInput extends StatelessWidget {
  const AdminDescriptionInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchEmployeeCubit, CreateBranchEmployeeState>(
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
                      .read<CreateBranchEmployeeCubit>()
                      .descriptionChanged(value);
                },
                hintText: "Enter description",
                maxLines: 6,
              )
            ],
          );
        });
  }
}
