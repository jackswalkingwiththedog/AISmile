import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/responsive/responsive.dart';
import 'package:venus/src/features/appointment/presentation/widgets/calendar.dart';
import 'package:venus/src/features/client/presentation/layout/client_layout.dart';
import 'package:venus/src/features/client/presentation/widget/appointment_screen_mobile/appointment_screen_mobile.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: AppointmentScreenView(),
      mobile: AppointmentScreenMobile(),
      tablet: AppointmentScreenMobile(),
    );
  }
}

class AppointmentScreenView extends StatelessWidget {
  const AppointmentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
      page: "appointment_page",
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) => previous != current,
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
                          child: Text("Appointment",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor("#DB1A20"),
                                  fontWeight: FontWeight.w900)),
                        ),
                      ]),
                  const SizedBox(height: 24),
                  Card(
                      child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 168,
                    child: Column(
                      children: [
                        BlocBuilder<AppBloc, AppState>(
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, state) {
                            return CalendarWidget(
                              customerId: uid,
                              doctorId: '',
                              role: Role.customer,
                            );
                          },
                        )
                      ],
                    ),
                  )),
                  // CreateAppointmentView(customerId: uid)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
