// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toastification/toastification.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/authentication/presentation/blocs/forgot_password/forgot_password_cubit.dart';
import 'package:venus/src/features/authentication/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/device/device.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.error) {}
        },
        child: Material(
          color: TColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color:
                      TDeviceUtils.isWeb() ? TColors.darkGrey : TColors.white)),
          child: const SizedBox(
            height: 364,
            width: 412,
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quên mật khẩu",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 32),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Chúng tôi sẻ gửi cho bạn một email để đổi mật khẩu'),
                          SizedBox(height: 16),
                          EmailInput(),
                          SizedBox(height: 32),
                          ForgotPasswordButton(),
                          SizedBox(height: 16),
                          BackToSignInButton(),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return AITextFormField(
            onChanged: (email) {
              context.read<ForgotPasswordCubit>().emailChanged(email);
            },
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person,
            hintText: "Email address",
          );
        });
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () async {
              await context
                  .read<ForgotPasswordCubit>()
                  .forgotPasswordSubmitting();

              if (context.read<ForgotPasswordCubit>().state.status ==
                  ForgotPasswordStatus.success) {
                toastification.show(
                  context: context,
                  title: 'Vui lòng kiểm tra email của bạn, để đổi mật khẩu!',
                  autoCloseDuration: const Duration(seconds: 5),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: HexColor("#DB1A20"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: state.status == ForgotPasswordStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text("Gửi mật khẩu", style: TextStyle(color: Colors.white)),
          );
        });
  }
}

class BackToSignInButton extends StatelessWidget {
  const BackToSignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/sign-in");
      },
      child:
          Text('Đăng nhập', style: TextStyle(color: HexColor("#DB1A20"))),
    );
  }
}
