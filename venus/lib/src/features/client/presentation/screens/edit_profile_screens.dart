import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
import 'package:venus/src/features/client/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/features/client/presentation/layout/client_layout.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
      page: "edit_profile_page",
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          final uid = context.read<AppBloc>().state.user.uid;
          // final role = context.read<AppBloc>().state.role;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.go("/");
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Home",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor("#DB1A20"),
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(EvaIcons.arrowIosForwardOutline,
                                color: HexColor("#DB1A20"), size: 20),
                            const SizedBox(height: 2),
                          ],
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          child: Text("Edit Profile",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor("#DB1A20"),
                                  fontWeight: FontWeight.w900)),
                        ),
                      ]),
                  const SizedBox(height: 24),
                  FutureBuilder(
                      future: CustomerRepository().getCustomer(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final customer = snapshot.data!;
                          return Row(
                            children: [
                              Expanded(
                                  flex: 12,
                                  child: Column(
                                    children: [
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
                                                  value:
                                                      customer.address ?? "")),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 6,
                                              child: GenderDropdown(
                                                  value:
                                                      customer.gender ?? "")),
                                          const SizedBox(width: 24),
                                          Expanded(
                                              flex: 6,
                                              child: CustomerBirthDayDialog(
                                                  value:
                                                      customer.birthday ?? "")),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 12,
                                              child: CustomerDescriptionInput(
                                                  value: customer.description ??
                                                      "")),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 80,
                                            child: CustomerCancelButton(
                                                customer: customer),
                                          ),
                                          const SizedBox(width: 24),
                                          SizedBox(
                                            height: 40,
                                            width: 104,
                                            child: CustomerUpdateButton(
                                                customer: customer,
                                                role: Role.customer),
                                          )
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomerCancelButton extends StatelessWidget {
  const CustomerCancelButton({Key? key, required this.customer})
      : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/profile");
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Full Name'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditProfileCubit>().nameChanged(value);
                },
                hintText: value == "" ? "Enter customer name" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    context.read<EditProfileCubit>().isAcceptEdit()
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<EditProfileCubit>().isAcceptEdit() == false) {
                return;
              }
              await context
                  .read<EditProfileCubit>()
                  .editProfileSubmitting(customer);

              // ignore: use_build_context_synchronously
              context.go('/profile');
            },
            child: state.status == EditProfileStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update'),
          );
        });
  }
}

class CustomerBirthDayDialog extends StatelessWidget {
  const CustomerBirthDayDialog({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        DateTime dateTime = dateFormat.parse(value);

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Birthday'),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
                    onPressed: () => showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: context.read<EditProfileCubit>(),
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
                        Text((state.birthday == "" ? value : state.birthday)),
                        const Icon(Icons.arrow_drop_down)
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
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
                      .read<EditProfileCubit>()
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              hintText: widget.value,
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  gender = value!;
                });
                context.read<EditProfileCubit>().genderChanged(value ?? "");
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
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
                  context.read<EditProfileCubit>().emailChanged(value);
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
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
                  context.read<EditProfileCubit>().phoneChanged(value);
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
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
                  context.read<EditProfileCubit>().addressChanged(value);
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
    return BlocBuilder<EditProfileCubit, EditProfileState>(
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
                  context.read<EditProfileCubit>().descriptionChanged(value);
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
