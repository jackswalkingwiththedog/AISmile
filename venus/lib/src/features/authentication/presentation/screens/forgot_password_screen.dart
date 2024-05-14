import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/common/widgets/header.dart';
import 'package:venus/src/features/authentication/presentation/blocs/forgot_password/forgot_password_cubit.dart';
import 'package:venus/src/features/authentication/presentation/widgets/forgot_form.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: BlocProvider<ForgotPasswordCubit>(
          create: (_) => ForgotPasswordCubit(AuthenticationRepository()),
          child: const SingleChildScrollView(
            child: Responsive(
              desktop: ForgotPasswordView(),
              tablet: ForgotPasswordView(),
              mobile: ForgotPasswordView(),
            ),
          ),
        )
      )
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return const SafeArea(child:Column(
      children: <Widget>[
        SizedBox(height: 24),
        HeaderWidget(),
        SizedBox(height: 68),
        ForgotPasswordForm(),
      ],
    ));
  }
}
