// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_event.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/file.dart';
import 'package:venus/src/utils/uuid.dart';

class ProfileScreenMobile extends StatelessWidget {
  const ProfileScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: BlocBuilder<AppBloc, AppState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            final uid = context.read<AppBloc>().state.user.uid;

            return FutureBuilder(
              future: CustomerRepository().getCustomer(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final customer = snapshot.data!;
                  return CustomScaffold(
                    appBar: CustomAppBar(
                      title: 'Trang cá nhân',
                      centerTitle: true,
                      onGoBack: () {
                        context.go('/');
                      },
                      actions: [CustomerUpdateButton(customer: customer)],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UpdateProfileView(customer: customer),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const Row();
              },
            );
          }),
    );
  }
}

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomerAvatar(customer: customer),
          const SizedBox(height: 16),
          CustomerName(name: customer.name ?? ""),
          CustomerGender(gender: customer.gender ?? ""),
          CustomerEmail(email: customer.email ?? ""),
          CustomerPhone(phone: customer.phone ?? ""),
          CustomerAddress(address: customer.address ?? ""),
          const SizedBox(height: 24),
          ElevatedButton(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(18.0))),
              onPressed: () {
                context.go("/");
                context.read<AppBloc>().add(const AppLogoutRequested());
              },
              child: const Text("Đăng xuất"))
        ],
      ),
    );
  }
}

class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.black12,
              child: customer.avatar == "" && state.avatar == ""
                  ? const SizedBox(
                      height: 108,
                      width: 108,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 18,
                        child: Icon(Icons.person,
                            color: TColors.primary, size: 40),
                      ),
                    )
                  : SizedBox(
                      height: 108,
                      width: 108,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: state.file.path == ""
                            ? Image(
                                image: NetworkImage(customer.avatar ?? ""),
                                fit: BoxFit.cover,
                                height: 108,
                                width: 108)
                            : Image.file(File(state.file.path),
                                fit: BoxFit.cover, height: 108, width: 108),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
                style: const ButtonStyle(
                    side: MaterialStatePropertyAll(
                        BorderSide(color: TColors.darkGrey)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.fromLTRB(16, 8, 16, 8))),
                onPressed: () async {
                  
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                          withData: true);

                  if (result != null && result.files.isNotEmpty) {
                    context.read<EditProfileCubit>().fileChanged(FileData(
                        path: result.files[0].path ?? "",
                        type: result.files[0].runtimeType,
                        bytes: result.files[0].bytes));
                  }

                  context.read<EditProfileCubit>().onSuccess();
                },
                child: const Text(
                  "Cập nhật",
                  style: TextStyle(color: TColors.darkGrey),
                )),
          ],
        );
      },
    );
  }
}

class CustomerUpdateButton extends StatelessWidget {
  const CustomerUpdateButton({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return TextButton(
          onPressed: () async {
            context.read<EditProfileCubit>().onSubmit();
            if (context.read<EditProfileCubit>().isAcceptEdit() == false) {
              return;
            }
            final filename = generateID();
            final image = await handleUploadPhotoFile(
                file: state.file,
                filename: filename,
                folder: "images/customer");
            context.read<EditProfileCubit>().avatarChanged(image);
            await context
                .read<EditProfileCubit>()
                .editProfileSubmitting(customer);
          },
          child: state.status == EditProfileStatus.submitting
              ? const ProgressIcon(color: TColors.white)
              : Text("Lưu",
                  style: TextStyle(
                      color: context.read<EditProfileCubit>().isAcceptEdit()
                          ? TColors.white
                          : Colors.grey)),
        );
      },
    );
  }
}

class CustomerName extends StatelessWidget {
  const CustomerName({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Họ và tên"),
            const SizedBox(height: 8),
            AITextFormField(
              contentPadding: const EdgeInsets.all(16),
              onChanged: (value) {
                context.read<EditProfileCubit>().nameChanged(value);
              },
              initialValue: name == "" ? "Nhập họ và tên" : name,
              hintText: name == "" ? "Nhập họ và tên" : name,
            ),
          ],
        );
      },
    );
  }
}

class CustomerEmail extends StatelessWidget {
  const CustomerEmail({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Email"),
            const SizedBox(height: 8),
            AITextFormField(
              contentPadding: const EdgeInsets.all(16),
              onChanged: (value) {
                context.read<EditProfileCubit>().emailChanged(value);
              },
              enabled: false,
              initialValue: email == "" ? "Nhập email" : email,
              hintText: email == "" ? "Nhập email" : email,
            ),
          ],
        );
      },
    );
  }
}

class CustomerPhone extends StatelessWidget {
  const CustomerPhone({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Số điện thoại"),
            const SizedBox(height: 8),
            AITextFormField(
              contentPadding: const EdgeInsets.all(16),
              onChanged: (value) {
                context.read<EditProfileCubit>().phoneChanged(value);
              },
              initialValue: phone == "" ? "Nhập số điện thoại" : phone,
              hintText: phone == "" ? "Nhập số điện thoại" : phone,
            ),
          ],
        );
      },
    );
  }
}

class CustomerAddress extends StatelessWidget {
  const CustomerAddress({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text("Địa chỉ"),
            const SizedBox(height: 8),
            AITextFormField(
              contentPadding: const EdgeInsets.all(16),
              onChanged: (value) {
                context.read<EditProfileCubit>().addressChanged(value);
              },
              initialValue: address == "" ? "Nhập điạ chỉ" : address,
              hintText: address == "" ? "Nhập điạ chỉ" : address,
              maxLines: 4,
            ),
          ],
        );
      },
    );
  }
}

const List<String> genders = <String>[
  'Nam',
  'Nữ',
  'Khác',
];

class CustomerGender extends StatefulWidget {
  const CustomerGender({super.key, required this.gender});

  final String gender;

  @override
  State<CustomerGender> createState() => _CustomerGenderState();
}

class _CustomerGenderState extends State<CustomerGender> {
  String gender = "Chọn giới tính";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text('Giới tính'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              hintText: widget.gender == "" ? "Chọn giới tính" : widget.gender,
              width: MediaQuery.of(context).size.width - 32,
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
              ),
              initialSelection: widget.gender,
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
          ],
        );
      },
    );
  }
}
