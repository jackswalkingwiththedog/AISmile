// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/customer/presentation/widgets/customer_information.dart';
import 'package:venus/src/features/order/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "order",
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
                  const Text('CREATE ORDER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  CreateOrderView(id: id),
                ],
              ),
            )));
  }
}

class CreateOrderView extends StatelessWidget {
  const CreateOrderView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderCubit, CreateOrderState>(
      listener: (context, state) {
        if (state.status == CreateOrderStatus.error) {}
      },
      child: Card(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 168,
              child: BlocBuilder<AppBloc, AppState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  final role = context.read<AppBloc>().state.role;
                  final uid = context.read<AppBloc>().state.user.uid;
                  if (role != Role.admin &&
                      role != Role.branchAdmin &&
                      role != Role.branchDoctor) {
                    return const Row();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: id == ""
                          ? Column(
                              children: [
                                FutureBuilder(
                                  future: CustomerRepository()
                                      .listCustomersWithUser(
                                          role: role, uid: uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      final customers = snapshot.data!.toList();
                                      return Row(
                                        children: [
                                          CustomerAssignDropdown(
                                              customers: customers)
                                        ],
                                      );
                                    }
                                    return const Row();
                                  },
                                ),
                                const CustomerData(),
                                // const SizedBox(height: 24),
                                // const Row(
                                //   children: [
                                //     Expanded(
                                //         flex: 4,
                                //         child: OrderPrintFrequencyInput()),
                                //     SizedBox(width: 24),
                                //     Expanded(
                                //         flex: 8, child: Text("Week / Time")),
                                //   ],
                                // ),
                                const SizedBox(height: 24),
                                const Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Images Scans"),
                                        SizedBox(height: 8),
                                        CustomerImagesInput()
                                      ],
                                    ))
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Row(
                                  children: [
                                    Expanded(
                                        flex: 12,
                                        child: OrderDescriptionInput()),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      child: OrderCancelButton(),
                                    ),
                                    const SizedBox(width: 24),
                                    SizedBox(
                                      child: OrderCreateButton(
                                          id: "", role: role, uid: uid),
                                    )
                                  ],
                                )
                              ],
                            )
                          : FutureBuilder(
                              future: CustomerRepository().getCustomer(id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  final customer = snapshot.data!;
                                  return Column(
                                    children: [
                                      CustomerInformation(customer: customer),
                                      const SizedBox(height: 24),
                                      const Row(
                                        children: [],
                                      ),
                                      // const SizedBox(height: 24),
                                      // const Row(
                                      //   children: [
                                      //     Expanded(
                                      //         flex: 4,
                                      //         child:
                                      //             OrderPrintFrequencyInput()),
                                      //     SizedBox(width: 24),
                                      //     Expanded(
                                      //         flex: 8,
                                      //         child: Text("Week / Time")),
                                      //   ],
                                      // ),
                                      const SizedBox(height: 24),
                                      const Row(
                                        children: [
                                          Expanded(
                                              flex: 12,
                                              child: OrderDescriptionInput()),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                            width: 80,
                                            child: OrderCancelButton(),
                                          ),
                                          const SizedBox(width: 24),
                                          SizedBox(
                                            height: 40,
                                            width: 104,
                                            child: OrderCreateButton(
                                                id: customer.uid,
                                                role: role,
                                                uid: uid),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                    ),
                  );
                },
              ))),
    );
  }
}

class CustomerData extends StatelessWidget {
  const CustomerData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
      buildWhen: (previous, current) =>
          previous.customerId != current.customerId,
      builder: (context, state) {
        return FutureBuilder(
            future: CustomerRepository().getCustomer(state.customerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final customer = snapshot.data!;
                return CustomerInformation(customer: customer);
              }
              return state.customerId == ""
                  ? const Row()
                  : const Center(child: CircularProgressIndicator());
            });
      },
    );
  }
}

class CustomerAssignDropdown extends StatefulWidget {
  const CustomerAssignDropdown({super.key, required this.customers});

  final List<Customer> customers;

  @override
  State<CustomerAssignDropdown> createState() => _CustomerAssignDropdownState();
}

class _CustomerAssignDropdownState extends State<CustomerAssignDropdown> {
  String doctorName = "Select Customer";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Customer'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              initialSelection: "",
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              hintText: "Select Customer",
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  doctorName = value!;
                });
                context.read<CreateOrderCubit>().customerIdChanged(value ?? "");
              },
              dropdownMenuEntries: widget.customers
                  .map<DropdownMenuEntry<String>>((Customer value) {
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

class OrderCreateButton extends StatelessWidget {
  const OrderCreateButton(
      {Key? key, required this.id, required this.role, required this.uid})
      : super(key: key);

  final String id;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<CreateOrderCubit>().isAcceptCreate(id)
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<CreateOrderCubit>().isAcceptCreate(id) ==
                  false) {
                return;
              }
              await context
                  .read<CreateOrderCubit>()
                  .createOrderSubmitting(customerId: id, role: role, uid: uid);
              context.go('/order');
            },
            child: state.status == CreateOrderStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Create', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class OrderCancelButton extends StatelessWidget {
  const OrderCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/order");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class OrderDescriptionInput extends StatelessWidget {
  const OrderDescriptionInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
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
                  context.read<CreateOrderCubit>().descriptionChanged(value);
                },
                hintText: "Enter description",
                maxLines: 6,
              )
            ],
          );
        });
  }
}

class OrderPrintFrequencyInput extends StatelessWidget {
  const OrderPrintFrequencyInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Print Frequency'),
              const SizedBox(height: 8),
              AITextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  context
                      .read<CreateOrderCubit>()
                      .printFrequencyChanged(value == "" ? "0" : value);
                },
                hintText: "Enter print frequency",
              )
            ],
          );
        });
  }
}

class CustomerImagesInput extends StatelessWidget {
  const CustomerImagesInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
        buildWhen: (previous, current) =>
            previous != current ||
            previous.images.length != current.images.length,
        builder: (context, state) {
          return SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 1024 + 64,
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
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
                                          .read<CreateOrderCubit>()
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
                                              .read<CreateOrderCubit>()
                                              .addImage(image: image);
                                        }
                                      }
                                      context
                                          .read<CreateOrderCubit>()
                                          .onSuccess();
                                    },
                                    child: state.status ==
                                            CreateOrderStatus.submitting
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
                                        height: state.images.isEmpty
                                            ? 0
                                            : state.images.length < 3
                                                ? 468
                                                : 468,
                                        width: 1024,
                                        child: Material(
                                          child: GridView.builder(
                                              itemCount: state.images.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 24,
                                                mainAxisSpacing: 24,
                                                crossAxisCount: 2,
                                              ),
                                              itemBuilder: (context, index) {
                                                return Material(
                                                  child: Row(children: [
                                                    Image.network(
                                                        state.images[index],
                                                        height: 468,
                                                        width: 468)
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
