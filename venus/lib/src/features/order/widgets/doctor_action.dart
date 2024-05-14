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
import 'package:venus/src/features/order/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class DoctorActionWidget extends StatelessWidget {
  const DoctorActionWidget({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AppBloc, AppState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                final role = context.read<AppBloc>().state.role;
                final uid = context.read<AppBloc>().state.user.uid;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("EDIT ORDER",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    SubmitEditAction(order: order, role: role, uid: uid)
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Images Scans"),
                    const SizedBox(height: 8),
                    CustomerImagesInput(order: order)
                  ],
                ))
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    flex: 12,
                    child:
                        OrderDescriptionInput(value: order.description ?? "")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPrintFrequencyInput extends StatelessWidget {
  const OrderPrintFrequencyInput({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOrderCubit, EditOrderState>(
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
                      .read<EditOrderCubit>()
                      .printFrequencyChanged(value == "" ? "0" : value);
                },
                hintText: value == "" ? "Enter print frequency" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class OrderDescriptionInput extends StatelessWidget {
  const OrderDescriptionInput({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOrderCubit, EditOrderState>(
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
                  context.read<EditOrderCubit>().descriptionChanged(value);
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

class CustomerImagesInput extends StatelessWidget {
  const CustomerImagesInput({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOrderCubit, EditOrderState>(
        buildWhen: (previous, current) =>
            previous != current ||
            previous.images.length != current.images.length,
        builder: (context, state) {

          final List<String> listImages = state.removedImages.isNotEmpty ? [...state.images] : [...state.images, ...order.images ?? []];

          return SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 1024,
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
                                      context.read<EditOrderCubit>().onSubmit();

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
                                              .read<EditOrderCubit>()
                                              .addImage(image: image);
                                        }
                                      }
                                      context
                                          .read<EditOrderCubit>()
                                          .onSuccess();
                                    },
                                    child: state.status ==
                                            EditOrderStatus.submitting
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
                                                ? 480
                                                : 480,
                                        width: 960,
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
                                                              context.read<EditOrderCubit>().removeImage(image: listImages[index], images: [...listImages], imagesOrder: order.images ?? [] );
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

class SubmitEditAction extends StatelessWidget {
  const SubmitEditAction(
      {super.key, required this.order, required this.role, required this.uid});

  final AlignerOrder order;
  final Role role;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOrderCubit, EditOrderState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AIButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              backgroundColor: MaterialStatePropertyAll(
                  (context.read<EditOrderCubit>().isAcceptEdit())
                      ? HexColor("#DB1A20")
                      : Colors.grey)),
          onPressed: () async {
            if (context.read<EditOrderCubit>().isAcceptEdit() == false) {
              return;
            }

            await context
                .read<EditOrderCubit>()
                .updateOrderSubmitting(order: order, role: role, uid: uid);
            context.go('/order/${order.id}');
          },
          icon: Icons.add,
          child: state.status == EditOrderStatus.submitting
              ? const ProgressIcon(color: Colors.white)
              : const Text('UPDATE', style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
