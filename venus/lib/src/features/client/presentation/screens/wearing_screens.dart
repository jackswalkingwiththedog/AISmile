import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_cubit.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_state.dart';
import 'package:venus/src/features/client/presentation/layout/client_layout.dart';
import 'package:venus/src/features/client/presentation/widget/wearing_input/wearing_input.dart';
import 'package:venus/src/features/client/presentation/widget/wearing_screen_mobile/wearing_screen_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/wearing_table/wearing_table.dart';
import 'package:venus/src/services/firestore/repository/wearing_repository.dart';

class WearingScreen extends StatelessWidget {
  const WearingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: WearingScreenMobile(), 
      tablet: WearingScreenMobile(), 
      desktop: WearingScreenView()
    );
  }
}

class WearingScreenView extends StatelessWidget {
  const WearingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
        page: "aligner_page",
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            final uid = context.read<AppBloc>().state.user.uid;
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
                                    color: HexColor("#DB1A20"), size: 20),
                                const SizedBox(height: 2),
                              ],
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {},
                              child: Text("Wearing",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor("#DB1A20"),
                                      fontWeight: FontWeight.w900)),
                            ),
                          ]),
                      const SizedBox(height: 24),
                      const WearingInput(),
                      const SizedBox(height: 12),
                      BlocBuilder<WearingCubit, WearingState>(
                        buildWhen: (previous, current) =>
                            previous.status == WearingStatus.submitting &&
                            current.status == WearingStatus.success,
                        builder: (context, state) {
                          return FutureBuilder(
                            future: WearingRepository().listWearings(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final wearings = snapshot.data!
                                    .where(
                                        (element) => element.customerId == uid)
                                    .toList();

                                wearings.sort((a, b) {
                                  DateFormat dateFormat =
                                      DateFormat('HH:mm dd/MM/yyyy');
                                  final timeA =
                                      dateFormat.parse(a.createTime ?? "");
                                  final timeB =
                                      dateFormat.parse(b.createTime ?? "");
                                  Duration durationA =
                                      DateTime.now().difference(timeA);
                                  Duration durationB =
                                      DateTime.now().difference(timeB);
                                  return durationA.inMinutes
                                      .compareTo(durationB.inMinutes);
                                });

                                return WearingTable(listWearing: wearings);
                              }

                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ));
          },
        ));
  }
}
