import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/features/client/presentation/layout/client_layout.dart';
import 'package:venus/src/features/client/presentation/widget/aligner_progress/aligner_progress.dart';
import 'package:venus/src/features/client/presentation/widget/aligner_screen_mobile/aligner_screen_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/aligner_table/aligner_table.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';

class AlignerScreen extends StatelessWidget {
  const AlignerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: AlignerScreenView(),
      mobile: AlignerScreenMobile(),
      tablet: AlignerScreenMobile(),
    );
  }
}

class AlignerScreenView extends StatelessWidget {
  const AlignerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
        page: "aligner_page",
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                Icon(EvaIcons.arrowIosForwardOutline,
                                    color: HexColor("#DB1A20"), size: 16),
                                const SizedBox(height: 2),
                              ],
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {},
                              child: Text("Aligner",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor("#DB1A20"),
                                      fontWeight: FontWeight.w900)),
                            ),
                          ]),
                      const SizedBox(height: 24),
                      FutureBuilder(
                        future: AlignerOrderRepository()
                            .listAlignerOrders(role: role, uid: uid),
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AlignerProgress(order: order),
                                const SizedBox(height: 24),
                                AlignerTable(order: order),
                              ],
                            );
                          }
                          return Center(
                              child: CircularProgressIndicator(
                                  color: HexColor("#DB1A20")));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
