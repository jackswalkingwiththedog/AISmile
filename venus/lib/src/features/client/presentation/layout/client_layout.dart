import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/features/client/presentation/widget/header/header.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';

class ClientLayout extends StatelessWidget {
  const ClientLayout({super.key, required this.child, required this.page});

  final String page;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ClientLayoutView(page: page, child: child),
      ),
    );
  }
}

class ClientLayoutView extends StatelessWidget {
  const ClientLayoutView({super.key, required this.child, required this.page});

  final String page;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          context.go("/sign-in");
          return const Row();
        }
        return Responsive(
            mobile: ClientLayoutMobileView(
              child: child,
            ),
            tablet: ClientLayoutMobileView(
              child: child,
            ),
            desktop: ClientLayoutDesktopView(child: child));
      },
    );
  }
}

class ClientLayoutMobileView extends StatelessWidget {
  const ClientLayoutMobileView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Header(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 90,
                child: child,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ClientLayoutDesktopView extends StatelessWidget {
  const ClientLayoutDesktopView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Header(),
              SizedBox(
                width: 1280,
                height: MediaQuery.of(context).size.height - 90,
                child: child,
              )
            ],
          )
        ],
      ),
    );
  }
}
