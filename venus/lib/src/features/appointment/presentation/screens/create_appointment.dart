import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/appointment/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/appointment/presentation/blocs/create/create_state.dart';
import 'package:venus/src/features/appointment/presentation/widgets/calendar.dart';

class CreateAppointmentScreen extends StatelessWidget {
  const CreateAppointmentScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "appointment",
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 65,
            color: const Color(0xFFFAFAFA),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CALENDAR APPOINMENT',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  CreateAppointmentView(customerId: uid)
                ],
              ),
            )));
  }
}

class CreateAppointmentView extends StatelessWidget {
  const CreateAppointmentView({Key? key, required this.customerId})
      : super(key: key);

  final String customerId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAppointmentCubit, CreateAppointmentState>(
      listener: (context, state) {
        if (state.status == CreateAppointmentStatus.error) {}
      },
      child: Card(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 168,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<AppBloc, AppState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        final doctorId = context.read<AppBloc>().state.user.uid;
                        final role = context.read<AppBloc>().state.role;
                        return CalendarWidget(
                          customerId: customerId,
                          doctorId: doctorId,
                          role: role,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
