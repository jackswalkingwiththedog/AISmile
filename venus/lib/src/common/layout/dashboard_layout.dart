import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/layout/sidebar_widgets.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/common/widgets/user.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;
  final String page;

  const DashboardLayout({Key? key, required this.child, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Responsive(
          desktop: DashboardLayoutView(page: page, child: child),
          tablet: const Row(),
          mobile: const Row(),
        ),
      ),
    );
  }
}

class DashboardLayoutView extends StatelessWidget {
  final Widget child;
  final String page;

  const DashboardLayoutView({Key? key, required this.child, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          context.go("/sign-in"); 
          return const Row(); 
        }
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: SideBarWidget(page: page),
            ),
            Expanded(
              flex: 10,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.black12,
                        )),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                        child: UserInformation(),
                      ),
                    ),
                    child,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
