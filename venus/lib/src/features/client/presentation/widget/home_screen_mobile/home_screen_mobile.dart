import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/client/presentation/widget/case_progress_mobile/case_progress_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/header_mobile/header_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/list_appointment_mobile/list_appointment_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/list_button/list_button.dart';
import 'package:venus/src/features/client/presentation/widget/list_case_progress_mobile/list_case_progress_mobile.dart';
import 'package:venus/src/features/client/presentation/widget/list_video_mobile/list_video_mobile.dart';
import 'package:venus/src/services/firebase_authentication/entities/firebase_user.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';

class HomeScreenMobileView extends StatelessWidget {
  const HomeScreenMobileView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          context.go('/');
        },
        child: CustomScaffold(
          appBar: CustomAppBar(
            actions: [
              BlocBuilder<AppBloc, AppState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    final user = context.read<AppBloc>().state.user;
                    return HeaderMobile(uid: user.uid);
                  }),
            ],
          ),
          body: BlocBuilder<AppBloc, AppState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                final uid = context.read<AppBloc>().state.user.uid;
                final role = context.read<AppBloc>().state.role;
                final user = context.read<AppBloc>().state.user;

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
                              CarouselView(order: order, user: user),
                              const ListButtonMobile(),
                              ListAppointmentMobile(
                                  navigate: "/",
                                  order: order, uid: uid, isShowFull: false),
                              ListCaseProgressMobile(
                                  order: order, uid: uid, isShowFull: false),
                              const ListVideoMobile()
                            ],
                          );
                        }
                        return const Row();
                      },
                    ),
                  ),
                );
              }),
        ));
  }
}

class CarouselView extends StatelessWidget {
  const CarouselView({super.key, required this.order, required this.user});

  final AlignerOrder order;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
      color: TColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            FutureBuilder(
              future: CustomerRepository().getCustomer(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final customer = snapshot.data!;
                  return CaseProgressMobile(
                      order: order, user: user, customer: customer);
                }
                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 108,
                          width: 108,
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
