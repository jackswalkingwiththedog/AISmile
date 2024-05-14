import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/common/widgets/header.dart';
import 'package:venus/src/services/firebase_authentication/repository/authentication_repository.dart';
import 'package:venus/src/features/authentication/presentation/blocs/signin/signin_cubit.dart';
import 'package:venus/src/features/authentication/presentation/widgets/signin_form.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: BlocProvider<SignInCubit>(
              create: (_) => SignInCubit(AuthenticationRepository()),
              child: const SingleChildScrollView(
                child: Responsive(
                  desktop: SignInView(),
                  tablet: SignInView(),
                  mobile: SignInView(),
                ),
              ),
            )));
  }
}

class SignInView extends StatelessWidget {
  const SignInView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        SizedBox(height: 24),
        HeaderWidget(),
        SizedBox(height: 68),
        SignInForm(),
      ],
    );
  }
}
