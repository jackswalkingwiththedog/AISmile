// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_cubit.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_state.dart';
import 'package:venus/src/features/client/presentation/widget/list_wearing_mobile/list_wearing_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/wearing_input/wearing_input.dart';
import 'package:venus/src/services/firestore/repository/wearing_repository.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/device/device.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class WearingScreenMobile extends StatelessWidget {
  const WearingScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          context.go('/');
        },
        child: CustomScaffold(
            appBar: CustomAppBar(
              title: 'Hình ảnh',
              centerTitle: true,
              onGoBack: () {
                context.go('/');
              },
            ),
            floatingActionButton: TDeviceUtils.isWeb()
                ? const Row()
                : FloatingActionButton(
                    backgroundColor: TColors.primary,
                    onPressed: () {
                      showDialog<Widget>(
                          context: context,
                          builder: (_) => BlocProvider.value(
                                value: context.read<WearingCubit>(),
                                child: const AlertDialog(
                                    insetPadding: EdgeInsets.all(16),
                                    contentPadding: EdgeInsets.all(0),
                                    content: CreateWearingDialog()),
                              ));
                    },
                    child: const Icon(Icons.image, color: TColors.white),
                  ),
            body: BlocBuilder<WearingCubit, WearingState>(
                buildWhen: (previous1, current1) =>
                    previous1.status != current1.status,
                builder: (context, state) {
                  return BlocBuilder<AppBloc, AppState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        final uid = context.read<AppBloc>().state.user.uid;
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: SingleChildScrollView(
                            child: FutureBuilder(
                              future: WearingRepository().listWearings(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  final wearings = snapshot.data!
                                      .where((element) =>
                                          element.customerId == uid)
                                      .toList();

                                  wearings.sort((a, b) {
                                    DateFormat dateFormat =
                                        DateFormat('HH:mm dd/MM/yyyy');
                                    final timeA =
                                        dateFormat.parse(a.createTime ?? "");
                                    final timeB =
                                        dateFormat.parse(b.createTime ?? "");
                                    Duration durationA =
                                        DateTime.now().difference(timeA);
                                    Duration durationB =
                                        DateTime.now().difference(timeB);
                                    return durationA.inMinutes
                                        .compareTo(durationB.inMinutes);
                                  });

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListWearingMobile(wearings: wearings)
                                    ],
                                  );
                                }

                                return const Row();
                              },
                            ),
                          ),
                        );
                      });
                })));
  }
}

class CreateWearingDialog extends StatelessWidget {
  const CreateWearingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WearingCubit, WearingState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: TColors.white,
            child: SizedBox(
              width: 468,
              height: state.files.isNotEmpty ? 456 + 346 / 3 * 2 : 456,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text("THÊM HÌNH ẢNH",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          IconButton(
                              style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: TColors.darkGrey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))))),
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        type: FileType.image,
                                        allowMultiple: true,
                                        withData: true);
                                if (result != null && result.files.isNotEmpty) {
                                  for (var file in result.files) {
                                    context.read<WearingCubit>().addFile(
                                        file: FileData(
                                            path: file.path ?? "",
                                            type: file.runtimeType,
                                            bytes: file.bytes));
                                  }
                                }
                              },
                              icon: const Icon(Icons.upload, size: 20)),
                          const SizedBox(width: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Chọn hình ảnh",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text("Kích thước nhỏ hơn 2MB",
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      state.files.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: SizedBox(
                                        width: 346,
                                        height: 346 / 3 * 2,
                                        child: Material(
                                          color: TColors.grey,
                                          child: GridView.builder(
                                              padding: const EdgeInsets.all(8),
                                              itemCount: state.files.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing: 0,
                                                      mainAxisSpacing: 0,
                                                      crossAxisCount: 1),
                                              itemBuilder: (context, index) {
                                                return Material(
                                                  color: TColors.grey,
                                                  surfaceTintColor:
                                                      TColors.black,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: SizedBox(
                                                        child: Image.file(
                                                      File(state
                                                          .files[index].path),
                                                      fit: BoxFit.fitHeight,
                                                      height: 346 / 3 * 2,
                                                    )),
                                                  ),
                                                );
                                              }),
                                        )))
                              ],
                            )
                          : const Row(),
                      const Row(
                        children: [
                          Expanded(flex: 12, child: WearingNoteInput())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<AppBloc, AppState>(
                            buildWhen: (previous, current) =>
                                previous != current,
                            builder: (context2, state2) {
                              final uid =
                                  context2.read<AppBloc>().state.user.uid;
                              return ElevatedButton(
                                style: ButtonStyle(
                                    side: MaterialStatePropertyAll(BorderSide(
                                        color: context
                                                .read<WearingCubit>()
                                                .isAcceptCreate()
                                            ? TColors.primary
                                            : TColors.grey)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        context
                                                .read<WearingCubit>()
                                                .isAcceptCreate()
                                            ? TColors.primary
                                            : TColors.darkGrey
                                                .withOpacity(0.7)),
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.all(16))),
                                onPressed: () async {
                                  if (!context
                                      .read<WearingCubit>()
                                      .isAcceptCreate()) {
                                    return;
                                  }
                                  context.read<WearingCubit>().onSubmit();
                                  final List<String> images = [];

                                  await Future.forEach(state.files,
                                      (file) async {
                                    final image = await handleUploadPhotoFile(
                                        file: file,
                                        filename: generateID(),
                                        folder: "images/wearing");
                                    images.add(image);
                                  });

                                  await context
                                      .read<WearingCubit>()
                                      .createWearinDebug(
                                          uid: uid, images: images);

                                  context.read<WearingCubit>().clearState();
                                  context.pop();
                                },
                                child: state.status == WearingStatus.loading
                                    ? const ProgressIcon(color: Colors.white)
                                    : const Text('Tải lên'),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
