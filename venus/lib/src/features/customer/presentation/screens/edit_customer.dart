// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/customer/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/customer/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class EditCustomerScreen extends StatelessWidget {
  const EditCustomerScreen({super.key, required this.id});

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
                  const Text('EDIT CUSTOMER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  EditCustomerView(id: id),
                ],
              ),
            )));
  }
}

class EditCustomerView extends StatelessWidget {
  const EditCustomerView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCustomerCubit, EditCustomerState>(
        listener: (context, state) {
          if (state.status == EditCustomerStatus.error) {}
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
                                          BranchAssignDropdown(
                                              branchs: branchs,
                                              customer: customer)
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
                                if (role != Role.admin &&
                                    role != Role.branchAdmin) {
                                  return const Row();
                                }
                                return FutureBuilder(
                                  future: BranchEmployeeRepository()
                                      .listBranchEmployees(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      final employees =
                                          snapshot.data!.where((element) {
                                        if (role == Role.admin &&
                                            element.role == "branch-doctor") {
                                          return true;
                                        }
                                        if (element.role == "branch-doctor" &&
                                            element.branchId ==
                                                customer.branchId) {
                                          return true;
                                        }
                                        return false;
                                      }).toList();

                                      return Row(
                                        children: [
                                          BlocBuilder<EditCustomerCubit,
                                              EditCustomerState>(
                                            buildWhen: (previous, current) =>
                                                previous.branchId !=
                                                current.branchId,
                                            builder: (context, state) {
                                              return EmployeeAssignDropdown(
                                                  employees: employees
                                                      .where((element) {
                                                    if (state.branchId != "") {
                                                      if (element.branchId ==
                                                          state.branchId) {
                                                        return true;
                                                      }
                                                      return false;
                                                    }

                                                    return customer.branchId ==
                                                        element.branchId;
                                                  }).toList(),
                                                  customer: customer);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    return const Row();
                                  },
                                );
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: CustomerNameInput(
                                        value: customer.name ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: CustomerEmailInput(
                                        value: customer.email ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: CustomerPhoneInput(
                                        value: customer.phone ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: CustomerAddressInput(
                                        value: customer.address ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: GenderDropdown(
                                        value: customer.gender ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: CustomerBirthDayDialog(
                                        value: customer.birthday ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Images Scans'),
                                        const SizedBox(height: 8),
                                        CustomerImagesInput(customer: customer)
                                      ],
                                    )),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: CustomerDescriptionInput(
                                        value: customer.description ?? "")),
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
                                    SizedBox(
                                      child: CustomerCancelButton(
                                          customer: customer),
                                    ),
                                    const SizedBox(width: 24),
                                    SizedBox(
                                      child: CustomerUpdateButton(
                                          customer: customer, role: role),
                                    )
                                  ],
                                );
                              },
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

class EmployeeAssignDropdown extends StatefulWidget {
  const EmployeeAssignDropdown(
      {super.key, required this.employees, required this.customer});

  final List<BranchEmployee> employees;
  final Customer customer;

  @override
  State<EmployeeAssignDropdown> createState() => _EmployeeAssignDropdownState();
}

class _EmployeeAssignDropdownState extends State<EmployeeAssignDropdown> {
  String doctorName = "Select Doctor";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final doctors = widget.employees
            .where((element) => element.uid == widget.customer.doctorId)
            .toList();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Doctor'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              initialSelection: "",
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              hintText: doctors.isNotEmpty ? doctors[0].name : "Select Doctor",
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  doctorName = value!;
                });
                context.read<EditCustomerCubit>().doctorIdChanged(value ?? "");
              },
              dropdownMenuEntries: widget.employees
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

class CustomerUpdateButton extends StatelessWidget {
  const CustomerUpdateButton(
      {Key? key, required this.customer, required this.role})
      : super(key: key);

  final Customer customer;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<EditCustomerCubit>().isAcceptEdit(role: role)
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<EditCustomerCubit>().isAcceptEdit(role: role) ==
                  false) {
                return;
              }
              await context
                  .read<EditCustomerCubit>()
                  .editCustomerSubmitting(customer);

              context.go('/customer/${customer.uid}');
            },
            child: state.status == EditCustomerStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class CustomerCancelButton extends StatelessWidget {
  const CustomerCancelButton({Key? key, required this.customer})
      : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/customer/${customer.uid}");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class CustomerNameInput extends StatelessWidget {
  const CustomerNameInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
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
                  context.read<EditCustomerCubit>().nameChanged(value);
                },
                hintText: value == "" ? "Enter customer name" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class CustomerBirthDayDialog extends StatelessWidget {
  const CustomerBirthDayDialog({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        DateTime dateTime = dateFormat.parse(value);

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
                              value: context.read<EditCustomerCubit>(),
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
                                  child: CustomerBirthdayPicker(
                                      dateTime: dateTime),
                                ),
                              )),
                        ),
                    child: Row(
                      children: [
                        Text((state.birthday == "" ? value : state.birthday),
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
  const CustomerBirthdayPicker({super.key, required this.dateTime});

  final DateTime dateTime;

  @override
  State<CustomerBirthdayPicker> createState() => _CustomerBirthdayPickerState();
}

class _CustomerBirthdayPickerState extends State<CustomerBirthdayPicker> {
  DateTime pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarDatePicker(
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialDate: widget.dateTime,
                onDateChanged: (date) {
                  setState(() {
                    pickedDate = date;
                  });
                  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
                  context
                      .read<EditCustomerCubit>()
                      .birthdayChanged(formattedDate);
                  Navigator.pop(context);
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
  const GenderDropdown({super.key, required this.value});

  final String value;

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String gender = "Select Gender";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer Gender', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              textStyle: const TextStyle(fontSize: 14),
              hintText: widget.value,
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  gender = value!;
                });
                context.read<EditCustomerCubit>().genderChanged(value ?? "");
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
  const CustomerEmailInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
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
                  context.read<EditCustomerCubit>().emailChanged(value);
                },
                hintText: value == '' ? "Enter customer email" : value,
                initialValue: value == "" ? "" : value,
                enabled: false,
              )
            ],
          );
        });
  }
}

class CustomerPhoneInput extends StatelessWidget {
  const CustomerPhoneInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
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
                  context.read<EditCustomerCubit>().phoneChanged(value);
                },
                hintText: value == "" ? "Enter customer phone number" : value,
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

class CustomerAddressInput extends StatelessWidget {
  const CustomerAddressInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
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
                  context.read<EditCustomerCubit>().addressChanged(value);
                },
                hintText: value == "" ? "Enter customer address" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class CustomerDescriptionInput extends StatelessWidget {
  const CustomerDescriptionInput({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
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
                  context.read<EditCustomerCubit>().descriptionChanged(value);
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
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: onPressed,
            child: state.status != EditCustomerStatus.submitting
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

class BranchAssignDropdown extends StatefulWidget {
  const BranchAssignDropdown(
      {super.key, required this.branchs, required this.customer});

  final List<Branch> branchs;
  final Customer customer;

  @override
  State<BranchAssignDropdown> createState() => _BranchAssignDropdownState();
}

class _BranchAssignDropdownState extends State<BranchAssignDropdown> {
  String branchName = "Select Dental Clinic";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final branchs = widget.branchs
            .where((element) => element.id == widget.customer.branchId)
            .toList();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Dental Clinic'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              initialSelection: "",
              hintText:
                  branchs.isNotEmpty ? branchs[0].name : "Select Dental Clinic",
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  branchName = value!;
                });
                context.read<EditCustomerCubit>().branchIdChanged(value ?? "");
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

class CustomerImagesInput extends StatelessWidget {
  const CustomerImagesInput({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditCustomerCubit, EditCustomerState>(
        buildWhen: (previous, current) =>
            previous != current ||
            previous.images.length != current.images.length,
        builder: (context, state) {
          final List<String> listImages = state.removedImages.isNotEmpty
              ? [...state.images]
              : [...state.images, ...customer.images ?? []];

          return SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 1024 + 64,
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(
                          color: HexColor("#DB1A20"),
                          style: BorderStyle.solid,
                          strokeAlign: 2,
                          width: 1,
                        )),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Upload Your Files",
                                        style: TextStyle(
                                          color: HexColor("#DB1A20"),
                                        )),
                                    const SizedBox(height: 8),
                                    const Text(
                                        "Drag a file here of browse for a file to upload",
                                        style:
                                            TextStyle(color: Colors.black45)),
                                  ],
                                ),
                                OutlinedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)))),
                                    onPressed: () async {
                                      context
                                          .read<EditCustomerCubit>()
                                          .onSubmit();

                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.image,
                                              allowMultiple: true, withData: true);
                                      if (result != null) {
                                        for (var file in result.files) {
                                          final image = await handleUploadPhoto(
                                              file: file,
                                              filename: generateID(),
                                              folder: "images/customer");
                                          context
                                              .read<EditCustomerCubit>()
                                              .addImage(image: image);
                                        }
                                      }
                                      context
                                          .read<EditCustomerCubit>()
                                          .onSuccess();
                                    },
                                    child: state.status ==
                                            EditCustomerStatus.submitting
                                        ? ProgressIcon(
                                            color: HexColor("#DB1A20"))
                                        : Row(
                                            children: [
                                              Icon(Icons.upload,
                                                  size: 16,
                                                  color: HexColor("#DB1A20")),
                                              const SizedBox(width: 4),
                                              Text("Browse File",
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#DB1A20"))),
                                            ],
                                          ))
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: SizedBox(
                                        height: listImages.isEmpty
                                            ? 0
                                            : listImages.length < 3
                                                ? 468
                                                : 468,
                                        width: 1024,
                                        child: Material(
                                          child: GridView.builder(
                                              itemCount: listImages.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 24,
                                                mainAxisSpacing: 24,
                                                crossAxisCount: 2,
                                              ),
                                              itemBuilder: (context, index) {
                                                return Material(
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.network(
                                                            listImages[index],
                                                            height: 396,
                                                            width: 396),
                                                        OutlinedButton(
                                                            style:
                                                                const ButtonStyle(
                                                              padding:
                                                                  MaterialStatePropertyAll(
                                                                      EdgeInsets
                                                                          .all(
                                                                              4.0)),
                                                              shape: MaterialStatePropertyAll(
                                                                  CircleBorder()),
                                                            ),
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      EditCustomerCubit>()
                                                                  .removeImage(
                                                                      image: listImages[
                                                                          index],
                                                                      images: [
                                                                        ...listImages
                                                                      ],
                                                                      imagesOrder:
                                                                          customer.images ??
                                                                              []);
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 14,
                                                              color: HexColor(
                                                                  "#DB1A20"),
                                                            )),
                                                      ]),
                                                );
                                              }),
                                        )))
                              ],
                            ),
                          ],
                        )),
                  ),
                )),
          );
        });
  }
}
