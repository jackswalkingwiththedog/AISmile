// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/customer/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/customer/presentation/blocs/create/create_state.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class CustomerImagesInput extends StatelessWidget {
  const CustomerImagesInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
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
                    color: Colors.white,
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
                                          .read<CreateCustomerCubit>()
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
                                              .read<CreateCustomerCubit>()
                                              .addImage(image: image);
                                        }
                                      }
                                      context
                                          .read<CreateCustomerCubit>()
                                          .onSuccess();
                                    },
                                    child: state.status ==
                                            CreateCustomerStatus.submitting
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
