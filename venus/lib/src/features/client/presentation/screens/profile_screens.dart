import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/features/client/presentation/layout/client_layout.dart';
import 'package:venus/src/features/client/presentation/widget/profile/profile.dart';
import 'package:venus/src/features/client/presentation/widget/profile_screen_mobile/profile_screen_mobile.dart';
import 'package:venus/src/features/customer/presentation/widgets/history.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: ProfileScreenView(),
      mobile: ProfileScreenMobile(),
      tablet: ProfileScreenMobile(),
    );
  }
}

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
      page: "profile_page",
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          final uid = context.read<AppBloc>().state.user.uid;
          final role = context.read<AppBloc>().state.role;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.go("/");
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Home",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor("#DB1A20"),
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 2),
                            Icon(EvaIcons.arrowIosForwardOutline,
                                color: HexColor("#DB1A20"), size: 20)
                          ],
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          child: Text("Profile",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor("#DB1A20"),
                                  fontWeight: FontWeight.w900)),
                        ),
                      ]),
                  const SizedBox(height: 24),
                  FutureBuilder(
                      future: CustomerRepository().getCustomer(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final customer = snapshot.data!;
                          return Row(
                            children: [
                              Expanded(
                                  flex: 12,
                                  child: Column(
                                    children: [
                                      ProfileWidget(customer: customer),
                                      const SizedBox(height: 24),
                                      HistoryCustomer(
                                          customer: customer, role: role),
                                    ],
                                  ))
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
