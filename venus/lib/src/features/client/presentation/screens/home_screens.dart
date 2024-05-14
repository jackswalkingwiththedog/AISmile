import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/features/client/presentation/layout/client_layout.dart';
import 'package:venus/src/features/client/presentation/widget/case_progress/case_progress.dart';
import 'package:venus/src/features/client/presentation/widget/group_button/group_button.dart';
import 'package:venus/src/features/client/presentation/widget/home_screen_mobile/home_screen_mobile.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: HomeScreenMobileView(),
      tablet: HomeScreenMobileView(),
      desktop: HomeScreenDesktopView(),
    );
  }
}

class HomeScreenDesktopView extends StatelessWidget {
  const HomeScreenDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
        page: "home_page",
        child: BlocBuilder<AppBloc, AppState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            final uid = context.read<AppBloc>().state.user.uid;
            final role = context.read<AppBloc>().state.role;
            return Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("AI SMILE",
                                          style: TextStyle(
                                              fontSize: 32,
                                              color: HexColor("#DB1A20"),
                                              fontWeight: FontWeight.w900))
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  FutureBuilder(
                                    future: AlignerOrderRepository()
                                        .listAlignerOrders(
                                            role: role, uid: uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        final orders = snapshot.data!
                                            .where((element) =>
                                                element.customerId == uid &&
                                                element.status == "wearing")
                                            .toList();

                                        final order = orders.first;
                                        return CaseProgress(order: order);
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  const GroupButton(),
                                ],
                              )),
                          const SizedBox(width: 86),
                          Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 32),
                                  Image.asset(
                                    "assets/images/banner-01.png",
                                    fit: BoxFit.fitHeight,
                                    height: 412,
                                  ),
                                  const SizedBox(height: 32),
                                  Text("Our Dental Services",
                                      style: TextStyle(
                                          fontSize: 32,
                                          color: HexColor("#DB1A20"))),
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                ));
          },
        ));
  }
}
