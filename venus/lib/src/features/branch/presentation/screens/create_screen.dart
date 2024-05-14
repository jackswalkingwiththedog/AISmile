import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/branch/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/branch/presentation/blocs/create/create_state.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class CreateBranchScreen extends StatelessWidget {
  const CreateBranchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "branch",
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
                  Text('CREATE DENTAL CLINIC',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  SizedBox(height: 24),
                  CreateBranchView(),
                ],
              ),
            )));
  }
}

class CreateBranchView extends StatelessWidget {
  const CreateBranchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBranchCubit, CreateBranchState>(
      listener: (context, state) {
        if (state.status == CreateBranchStatus.error) {}
      },
      child: Card(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 168,
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 6, child: BranchNameInput()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: BranchEmailInput()),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(flex: 6, child: BranchPhoneInput()),
                        SizedBox(width: 24),
                        Expanded(flex: 6, child: BranchAddressInput()),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(flex: 12, child: BranchPhotoInput()),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(flex: 12, child: BranchDescriptionInput()),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: BranchCancelButton(),
                        ),
                        SizedBox(width: 24),
                        SizedBox(
                          child: BranchCreateButton(),
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

class BranchCreateButton extends StatelessWidget {
  const BranchCreateButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return AIButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                ),
                backgroundColor: MaterialStatePropertyAll(
                    context.read<CreateBranchCubit>().isAcceptCreate()
                        ? HexColor("#DB1A20")
                        : Colors.grey)),
            onPressed: () async {
              if (context.read<CreateBranchCubit>().isAcceptCreate() == false) {
                return;
              }
              await context.read<CreateBranchCubit>().createBranchSubmitting();
              // ignore: use_build_context_synchronously
              context.go('/branch');
            },
            child: state.status == CreateBranchStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Create', style: TextStyle(
                  color: Colors.white
                )),
          );
        });
  }
}

class BranchCancelButton extends StatelessWidget {
  const BranchCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/branch");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class BranchNameInput extends StatelessWidget {
  const BranchNameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
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
                  context.read<CreateBranchCubit>().nameChanged(value);
                },
                hintText: "Enter dental clinic name",
              )
            ],
          );
        });
  }
}

class BranchEmailInput extends StatelessWidget {
  const BranchEmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
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
                  context.read<CreateBranchCubit>().emailChanged(value);
                },
                hintText: "Enter dental clinic email",
              )
            ],
          );
        });
  }
}

class BranchPhoneInput extends StatelessWidget {
  const BranchPhoneInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
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
                  context.read<CreateBranchCubit>().phoneChanged(value);
                },
                hintText: "Enter dental clinic phone number",
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
  const BranchAddressInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
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
                  context.read<CreateBranchCubit>().addressChanged(value);
                },
                hintText: "Enter dental clinic address",
              )
            ],
          );
        });
  }
}

class BranchPhotoInput extends StatelessWidget {
  const BranchPhotoInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
        buildWhen: (previous, current) => previous.logo != current.logo,
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Logo'),
              const SizedBox(height: 8),
              Row(
                children: [
                  PhotoButtonInput(
                    onPressed: () async {
                      context.read<CreateBranchCubit>().onSubmit();
                      final logo = await handleUploadImage(
                          filename: generateID(), folder: "images/branch");
                      // ignore: use_build_context_synchronously
                      context.read<CreateBranchCubit>().logoChanged(logo);
                      // ignore: use_build_context_synchronously
                      context.read<CreateBranchCubit>().onSuccess();
                    },
                  ),
                  const SizedBox(width: 24),
                  state.logo != ""
                      ? PhotoInputView(image: state.logo)
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
        borderRadius: const BorderRadius.all(Radius.circular(4)),
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
  const BranchDescriptionInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
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
                  context.read<CreateBranchCubit>().descriptionChanged(value);
                },
                hintText: "Enter description",
                maxLines: 6,
              )
            ],
          );
        });
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
    return BlocBuilder<CreateBranchCubit, CreateBranchState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Material(
          child: InkWell(
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
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
              child: state.status != CreateBranchStatus.submitting
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
