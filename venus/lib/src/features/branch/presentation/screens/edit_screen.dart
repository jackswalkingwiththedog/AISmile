import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/branch/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/branch/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class EditBranchScreen extends StatelessWidget {
  const EditBranchScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "branch",
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
                  const Text('EDIT DENTAL CLINIC',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  EditBranchView(id: id),
                ],
              ),
            )));
  }
}

class EditBranchView extends StatelessWidget {
  const EditBranchView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBranchCubit, EditBranchState>(
        listener: (context, state) {
          if (state.status == EditBranchStatus.error) {}
        },
        child: FutureBuilder(
          future: BranchRepository().getBranch(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final branch = snapshot.data!;
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CreateDoctorButton(id: id),
                                const SizedBox(width: 16),
                                CreateAdminButton(id: id)
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: BranchNameInput(
                                        value: branch.name ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: BranchEmailInput(
                                        value: branch.email ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: BranchPhoneInput(
                                        value: branch.phone ?? "")),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 6,
                                    child: BranchAddressInput(
                                        value: branch.address ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: BranchPhotoInput(
                                        value: branch.logo ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    flex: 12,
                                    child: BranchDescriptionInput(
                                        value: branch.description ?? "")),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: BranchCancelButton(branch: branch),
                                ),
                                const SizedBox(width: 24),
                                SizedBox(
                                  child: BranchEditButton(branch: branch),
                                )
                              ],
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

class BranchEditButton extends StatelessWidget {
  const BranchEditButton({Key? key, required this.branch}) : super(key: key);

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                ),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<EditBranchCubit>().isAcceptEdit()
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<EditBranchCubit>().isAcceptEdit() == false) {
                return;
              }
              await context
                  .read<EditBranchCubit>()
                  .editBranchSubmitting(branch);
              // ignore: use_build_context_synchronously
              context.go('/branch/${branch.id}');
            },
            child: state.status == EditBranchStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update', style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class BranchCancelButton extends StatelessWidget {
  const BranchCancelButton({
    Key? key,
    required this.branch,
  }) : super(key: key);

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/branch/${branch.id}");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class BranchNameInput extends StatelessWidget {
  const BranchNameInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dental Clinic Name'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchCubit>().nameChanged(value);
                },
                hintText: value == "" ? "Enter dental clinic name" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class BranchEmailInput extends StatelessWidget {
  const BranchEmailInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dental Clinic Email'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchCubit>().emailChanged(value);
                },
                hintText: value == '' ? "Enter dental clinic email" : value,
                enabled: false,
              )
            ],
          );
        });
  }
}

class BranchPhoneInput extends StatelessWidget {
  const BranchPhoneInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dental Clinic Phone'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchCubit>().phoneChanged(value);
                },
                hintText:
                    value == "" ? "Enter dental clinic phone number" : value,
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

class BranchAddressInput extends StatelessWidget {
  const BranchAddressInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dental Clinic Address'),
              const SizedBox(height: 8),
              AITextFormField(
                onChanged: (value) {
                  context.read<EditBranchCubit>().addressChanged(value);
                },
                hintText: value == "" ? "Enter dental clinic address" : value,
                initialValue: value == "" ? "" : value,
              )
            ],
          );
        });
  }
}

class BranchPhotoInput extends StatelessWidget {
  const BranchPhotoInput({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
        buildWhen: (previous, current) => previous.logo != current.logo,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Photo'),
              const SizedBox(height: 8),
              Row(
                children: [
                  PhotoButtonInput(
                    onPressed: () async {
                      context.read<EditBranchCubit>().onSubmit();
                      final logo = await handleUploadImage(
                          filename: generateID(), folder: "images/branch");
                      // ignore: use_build_context_synchronously
                      context.read<EditBranchCubit>().logoChanged(logo);
                      // ignore: use_build_context_synchronously
                      context.read<EditBranchCubit>().onSuccess();
                    },
                  ),
                  const SizedBox(width: 24),
                  (value != "")
                      ? PhotoInputView(
                          image: state.logo == "" ? value : state.logo)
                      : const Row(),
                ],
              )
            ],
          );
        });
  }
}

class PhotoInputView extends StatelessWidget {
  const PhotoInputView({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.network(image, height: 100, width: 140)],
      ),
    );
  }
}

class BranchDescriptionInput extends StatelessWidget {
  const BranchDescriptionInput({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
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
                  context.read<EditBranchCubit>().descriptionChanged(value);
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

class CreateDoctorButton extends StatelessWidget {
  const CreateDoctorButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-doctor/$id");
      },
      icon: Icons.add,
      child: const Text('Add Doctor', style: TextStyle(color: Colors.white)),
    );
  }
}

class CreateAdminButton extends StatelessWidget {
  const CreateAdminButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-admin/$id");
      },
      icon: Icons.add,
      child: const Text('Add Admin', style: TextStyle(color: Colors.white)),
    );
  }
}

class PhotoButtonInput extends StatelessWidget {
  const PhotoButtonInput({
    Key? key,
    this.onPressed,
    this.image,
  }) : super(key: key);

  final void Function()? onPressed;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBranchCubit, EditBranchState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Material(
          child: InkWell(
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              side: BorderSide(),
            ),
            onTap: onPressed,
            child: Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  width: 0.5,
                ),
              ),
              child: state.status != EditBranchStatus.submitting
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 24,
                        ),
                        Text('Image'),
                      ],
                    )
                  : ProgressIcon(color: HexColor("#DB1A20")),
            ),
          ),
        );
      },
    );
  }
}
