// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toastification/toastification.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/icon_button.dart';
import 'package:venus/src/common/components/text_form_field.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/authentication/presentation/blocs/signin/signin_cubit.dart';
import 'package:venus/src/features/authentication/presentation/blocs/signin/signin_state.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/device/device.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.status == SignInStatus.error) {
            
          }
        },
        child: Material(
          color: TColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color:
                      TDeviceUtils.isWeb() ? TColors.darkGrey : TColors.white)),
          child: const SizedBox(
            height: 412,
            width: 412,
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đăng nhập",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 32),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EmailInput(),
                          SizedBox(height: 16),
                          PasswordInput(),
                          SizedBox(height: 32),
                          SignInButton(),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ForgotPasswordButton(),
                              BackToHomeButton()
                            ],
                          ),
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
    return BlocBuilder<SignInCubit, SignInState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return AITextFormField(
            onChanged: (email) {
              context.read<SignInCubit>().emailChanged(email);
            },
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person,
            hintText: "Email",
          );
        });
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return AITextFormField(
            obscureText: _obscureText,
            onChanged: (password) {
              context.read<SignInCubit>().passwordChanged(password);
            },
            hintText: "Mật khẩu",
            suffixIcon: AIIconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            prefixIcon: Icons.lock,
          );
        });
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return BlocBuilder<AppBloc, AppState>(
            builder: (context, state2) {
              return ElevatedButton(
                onPressed: () async {
                  await context.read<SignInCubit>().signInFormSubmitting();

                  if (context.read<SignInCubit>().state.status ==
                      SignInStatus.error) {
                    toastification.show(
                      context: context,
                      title: 'Sai tài khoản hoặc mật khẩu!',
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                  }

                  final role = context.read<AppBloc>().state.role;

                  if (role == Role.admin) {
                    context.go("/branch");
                    return;
                  }
                  if (role == Role.branchAdmin) {
                    context.go("/doctor");
                    return;
                  }
                  if (role == Role.branchDoctor ||
                      role == Role.designer ||
                      role == Role.leadDesigner ||
                      role == Role.printer ||
                      role == Role.reviewer ||
                      role == Role.shipper) {
                    context.go("/customer");
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: HexColor("#DB1A20"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                child: state.status == SignInStatus.submitting
                    ? const ProgressIcon(color: Colors.white)
                    : const Text("Đăng nhập",
                        style: TextStyle(color: Colors.white)),
              );
            },
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
    return TextButton(
      onPressed: () => context.go("/forgot-password"),
      child:
          Text('Quên mật khẩu ?', style: TextStyle(color: HexColor("#DB1A20"))),
    );
  }
}

class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/home");
      },
      child: Text('Trang chủ', style: TextStyle(color: HexColor("#DB1A20"))),
    );
  }
}
