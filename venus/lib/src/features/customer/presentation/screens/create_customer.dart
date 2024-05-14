import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/customer/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/customer/presentation/blocs/create/create_state.dart';
import 'package:venus/src/features/customer/presentation/widgets/customer_images_input.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class CreateCustomerScreen extends StatelessWidget {
  const CreateCustomerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "customer",
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 65,
            color: const Color(0xFFFAFAFA),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CREATE CUSTOMER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(height: 24),
                  CreateCustomerView(),
                ],
              ),
            )));
  }
}

class CreateCustomerView extends StatelessWidget {
  const CreateCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCustomerCubit, CreateCustomerState>(
      listener: (context, state) {
        if (state.status == CreateCustomerStatus.error) {}
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
                    BlocBuilder<AppBloc, AppState>(
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
                    ),
                    BlocBuilder<AppBloc, AppState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        final role = context.read<AppBloc>().state.role;
                        final uid = context.read<AppBloc>().state.user.uid;

                        if (role != Role.branchAdmin && role != Role.admin) {
                          return const Row();
                        }
                        return FutureBuilder(
                          future: BranchEmployeeRepository()
                              .listBranchEmployeesWithUser(
                            role: role,
                            uid: uid,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final employees = snapshot.data!
                                  .where((element) =>
                                      element.role == "branch-doctor")
                                  .toList();
                              return Row(
                                children: [
                                  BlocBuilder<CreateCustomerCubit,
                                      CreateCustomerState>(
                                    buildWhen: (previous, current) =>
                                        previous.branchId != current.branchId,
                                    builder: (context, state) {
                                      return DoctorAssignDropdown(
                                          employees: employees.where((element) {
                                        if (role == Role.branchAdmin) {
                                          return true;
                                        } else {
                                          if (element.branchId ==
                                              state.branchId) {
                                            return true;
                                          }
                                          return false;
                                        }
                                      }).toList());
                                    },
                                  )
                                ],
                              );
                            }
                            return const Row();
                          },
                        );
                      },
                    ),
                    const Row(
                      children: [
                        Expanded(flex: 6, child: CustomerNameInput()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: CustomerEmailInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(flex: 6, child: CustomerPhoneInput()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: CustomerAddressInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(flex: 6, child: GenderDropdown()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: CustomerBirthDayDialog()),
                      ],
                    ),
                    const Row(
                      children: [
                        Expanded(
                            flex: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Images Scans'),
                                SizedBox(height: 8),
                                CustomerImagesInput()
                              ],
                            )),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(flex: 12, child: CustomerDescriptionInput()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<AppBloc, AppState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status,
                        builder: (context, state) {
                          final role = context.read<AppBloc>().state.role;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                child: CustomerCancelButton(),
                              ),
                              const SizedBox(width: 24),
                              SizedBox(
                                child: CustomerCreateButton(role: role),
                              )
                            ],
                          );
                        }),
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
  String branchName = "Select Dental Clinic";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
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
              hintText: "Select Dental Clinic",
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  branchName = value!;
                });
                context
                    .read<CreateCustomerCubit>()
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

class DoctorAssignDropdown extends StatefulWidget {
  const DoctorAssignDropdown({super.key, required this.employees});

  final List<BranchEmployee> employees;

  @override
  State<DoctorAssignDropdown> createState() => _DoctorAssignDropdownState();
}

class _DoctorAssignDropdownState extends State<DoctorAssignDropdown> {
  String doctorName = "Select Doctor";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
      buildWhen: (previous, current) => previous.branchId != current.branchId,
      builder: (context, state) {
        final employees = widget.employees;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Doctor'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              initialSelection: "",
              hintText: "Select Doctor",
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  doctorName = value!;
                });
                context
                    .read<CreateCustomerCubit>()
                    .doctorIdChanged(value ?? "");
              },
              dropdownMenuEntries: employees
                  .map<DropdownMenuEntry<String>>((BranchEmployee value) {
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

class FileInputView extends StatelessWidget {
  const FileInputView({
    super.key,
    required this.file,
  });

  final String file;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              if (!file.contains("https://")) {
                launchUrlString("https://$file");
              } else {
                launchUrlString(file);
              }
            },
            child: Text(
                file.length <= 40 ? file : "${file.substring(0, 40)}...",
                style: TextStyle(color: HexColor("#DB1A20")))),
      ],
    );
  }
}

class CustomerCreateButton extends StatelessWidget {
  const CustomerCreateButton({Key? key, required this.role}) : super(key: key);

  final Role role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          final uid = context.read<AppBloc>().state.user.uid;
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(context
                        .read<CreateCustomerCubit>()
                        .isAcceptCreate(role: role)
                    ? HexColor("#DB1A20")
                    : Colors.grey)),
            onPressed: () async {
              try {
                if (context
                        .read<CreateCustomerCubit>()
                        .isAcceptCreate(role: role) ==
                    false) {
                  return;
                }
                await context
                    .read<CreateCustomerCubit>()
                    .createCustomerSubmitting(uid: uid, role: role);
                // ignore: use_build_context_synchronously
                context.go('/customer');
              } catch (_) {
                return;
              }
            },
            child: state.status == CreateCustomerStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Create', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class CustomerCancelButton extends StatelessWidget {
  const CustomerCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/customer");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class CustomerNameInput extends StatelessWidget {
  const CustomerNameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Name'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<CreateCustomerCubit>().nameChanged(value);
                },
                hintText: "Enter customer name",
              )
            ],
          );
        });
  }
}

class CustomerBirthDayDialog extends StatelessWidget {
  const CustomerBirthDayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer Birthday'),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                    style: const ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                        padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
                    onPressed: () => showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: context.read<CreateCustomerCubit>(),
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                shadowColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                backgroundColor: Colors.white,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  height: 412,
                                  width: 486,
                                  child: const CustomerBirthdayPicker(),
                                ),
                              )),
                        ),
                    child: Row(
                      children: [
                        Text(
                            state.birthday == ""
                                ? DateFormat("dd/MM/yyyy")
                                    .format(DateTime.now())
                                : state.birthday,
                            style: TextStyle(color: HexColor("#DB1A20"))),
                        Icon(Icons.arrow_drop_down, color: HexColor("#DB1A20"))
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class CustomerBirthdayPicker extends StatefulWidget {
  const CustomerBirthdayPicker({super.key});

  @override
  State<CustomerBirthdayPicker> createState() => _CustomerBirthdayPickerState();
}

class _CustomerBirthdayPickerState extends State<CustomerBirthdayPicker> {
  DateTime pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarDatePicker(
                firstDate: DateTime(1800),
                lastDate: DateTime.now(),
                initialDate: pickedDate,
                onDateChanged: (date) {
                  setState(() {
                    pickedDate = date;
                  });
                  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
                  context
                      .read<CreateCustomerCubit>()
                      .birthdayChanged(formattedDate);
                },
              ),
            ],
          );
        });
  }
}

const List<String> genders = <String>[
  'Male',
  'Female',
];

class GenderDropdown extends StatefulWidget {
  const GenderDropdown({super.key});

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String gender = "Select Gender";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer Gender'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              textStyle: const TextStyle(fontSize: 14),
              hintText: "Select gender",
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  gender = value!;
                });
                context.read<CreateCustomerCubit>().genderChanged(value ?? "");
              },
              dropdownMenuEntries:
                  genders.map<DropdownMenuEntry<String>>((String value) {
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

class CustomerEmailInput extends StatelessWidget {
  const CustomerEmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Email'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<CreateCustomerCubit>().emailChanged(value);
                },
                hintText: "Enter customer email",
              )
            ],
          );
        });
  }
}

class CustomerPhoneInput extends StatelessWidget {
  const CustomerPhoneInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Phone'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<CreateCustomerCubit>().phoneChanged(value);
                },
                hintText: "Enter customer phone number",
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

class CustomerAddressInput extends StatelessWidget {
  const CustomerAddressInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Address'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<CreateCustomerCubit>().addressChanged(value);
                },
                hintText: "Enter customer address",
              )
            ],
          );
        });
  }
}

class CustomerDescriptionInput extends StatelessWidget {
  const CustomerDescriptionInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
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
                  context.read<CreateCustomerCubit>().descriptionChanged(value);
                },
                hintText: "Enter description",
                maxLines: 6,
              )
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
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: onPressed,
            child: state.status != CreateCustomerStatus.submitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload,
                        size: 24,
                      ),
                      Text('Upload'),
                    ],
                  )
                : ProgressIcon(color: HexColor("#DB1A20")));
      },
    );
  }
}
