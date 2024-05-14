// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_cubit.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_state.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class WearingInput extends StatelessWidget {
  const WearingInput({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<WearingCubit, WearingState>(
        buildWhen: (previous, current) =>
            previous != current ||
            previous.images.length != current.images.length,
        builder: (context, state) {
          return SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: size.width > 1024 ? 568 + 64 : size.width - 48,
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
                        padding: size.width > 1024
                            ? const EdgeInsets.fromLTRB(32, 16, 32, 16)
                            : const EdgeInsets.all(12),
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
                                size.width > 1024
                                    ? OutlinedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)))),
                                        onPressed: () async {
                                          context
                                              .read<WearingCubit>()
                                              .onSubmit();

                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.image,
                                                      allowMultiple: true, withData: true);
                                          if (result != null) {
                                            for (var file in result.files) {
                                              final image =
                                                  await handleUploadPhoto(
                                                      file: file,
                                                      filename: generateID(),
                                                      folder: "images/wearing");
                                              context
                                                  .read<WearingCubit>()
                                                  .addImage(image: image);
                                            }
                                          }
                                          context
                                              .read<WearingCubit>()
                                              .onSuccess();
                                        },
                                        child: state.status ==
                                                WearingStatus.submitting
                                            ? ProgressIcon(
                                                color: HexColor("#DB1A20"))
                                            : Row(
                                                children: [
                                                  Icon(Icons.upload,
                                                      size: 16,
                                                      color:
                                                          HexColor("#DB1A20")),
                                                  const SizedBox(width: 4),
                                                  Text("Browse File",
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              "#DB1A20"))),
                                                ],
                                              ))
                                    : const SizedBox(width: 0),
                              ],
                            ),
                            const SizedBox(height: 24),
                            size.width <= 1024
                                ? OutlinedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)))),
                                    onPressed: () async {
                                      context.read<WearingCubit>().onSubmit();

                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              type: FileType.image,
                                              allowMultiple: true);
                                      if (result != null) {
                                        for (var file in result.files) {
                                          final image = await handleUploadPhoto(
                                              file: file,
                                              filename: generateID(),
                                              folder: "images/wearing");
                                          context
                                              .read<WearingCubit>()
                                              .addImage(image: image);
                                        }
                                      }
                                      context.read<WearingCubit>().onSuccess();
                                    },
                                    child: state.status ==
                                            WearingStatus.submitting
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
                                : const SizedBox(width: 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: SizedBox(
                                        height: state.images.isEmpty
                                            ? 0
                                            : state.images.length < 3
                                                ? 286
                                                : 300,
                                        width: size.width > 1024
                                            ? 568
                                            : size.width - 96,
                                        child: Material(
                                          child: GridView.builder(
                                              itemCount: state.images.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 24,
                                                mainAxisSpacing: 24,
                                                crossAxisCount:
                                                    size.width > 1024 ? 2 : 1,
                                              ),
                                              itemBuilder: (context, index) {
                                                return Material(
                                                  child: Row(children: [
                                                    Image.network(
                                                        state.images[index],
                                                        height: size.width >
                                                                1024
                                                            ? 268
                                                            : size.width - 96,
                                                        width: size.width > 1024
                                                            ? 268
                                                            : size.width - 96)
                                                  ]),
                                                );
                                              }),
                                        )))
                              ],
                            ),
                            state.images.isEmpty
                                ? const Row()
                                : const Row(
                                    children: [
                                      Expanded(
                                          flex: 12, child: WearingNoteInput())
                                    ],
                                  ),
                            state.images.isEmpty
                                ? const Row()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const WearingCloseButton(),
                                      const SizedBox(width: 24),
                                      BlocBuilder<AppBloc, AppState>(
                                        buildWhen: (previous, current) =>
                                            previous != current,
                                        builder: (context, state) {
                                          final uid = context
                                              .read<AppBloc>()
                                              .state
                                              .user
                                              .uid;
                                          return WearingCreateButton(uid: uid);
                                        },
                                      )
                                    ],
                                  ),
                            const SizedBox(height: 24),
                          ],
                        )),
                  ),
                )),
          );
        });
  }
}

class WearingNoteInput extends StatelessWidget {
  const WearingNoteInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WearingCubit, WearingState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Ghi chú",
                  style: TextStyle(
                    color: TColors.black,
                  )),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<WearingCubit>().noteChanged(value);
                },
                hintText: "Nhập ghi chú",
                maxLines: 6,
              ),
              const SizedBox(height: 24),
            ],
          );
        });
  }
}

class WearingCreateButton extends StatelessWidget {
  const WearingCreateButton({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<WearingCubit, WearingState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return ElevatedButton(
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                    Size(size.width > 1024 ? 148 : 120, 40)),
                backgroundColor: MaterialStatePropertyAll(HexColor("#DB1A20"))),
            onPressed: () async {
              await context.read<WearingCubit>().createWearing(uid: uid);
              context.read<WearingCubit>().clearState();
            },
            child: state.status == WearingStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Hoàn thành'),
          );
        });
  }
}

class WearingCloseButton extends StatelessWidget {
  const WearingCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<WearingCubit, WearingState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                  Size(size.width > 1024 ? 148 : 120, 40)),
            ),
            onPressed: () {
              context.read<WearingCubit>().clearState();
            },
            child: const Text('Close', style: TextStyle(color: Colors.black54)),
          );
        });
  }
}
