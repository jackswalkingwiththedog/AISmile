import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/client/presentation/widget/list_appointment_mobile/list_appointment_mobile.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';

class AppointmentScreenMobile extends StatelessWidget {
  const AppointmentScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          context.go('/');
        },
        child: CustomScaffold(
            appBar: CustomAppBar(
              title: 'Lịch hẹn',
              centerTitle: true,
              onGoBack: () {
                context.go('/');
              },
            ),
            body: BlocBuilder<AppBloc, AppState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                final uid = context.read<AppBloc>().state.user.uid;
                final role = context.read<AppBloc>().state.role;

                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                      future: AlignerOrderRepository()
                          .listAlignerOrders(role: role, uid: uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
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
                              ListAppointmentMobile(
                                  navigate: "/appointments",
                                  order: order,
                                  uid: uid,
                                  isShowFull: true),
                            ],
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: SizedBox(
                              child: Column(
                            children: [
                              const SizedBox(height: 32),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 140,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 16),
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: TColors.black
                                                      .withOpacity(0.1)),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          color: Colors.white,
                                        ),
                                      ));
                                },
                              )
                            ],
                          )),
                        );
                      },
                    ),
                  ),
                );
              },
            )));
  }
}
