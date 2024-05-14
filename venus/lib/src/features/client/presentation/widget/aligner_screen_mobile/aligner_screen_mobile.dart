import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/client/presentation/widget/list_case_progress_mobile/list_case_progress_mobile.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';

class AlignerScreenMobile extends StatelessWidget {
  const AlignerScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          context.go('/');
        },
        child: CustomScaffold(
            appBar: CustomAppBar(
              title: 'Lịch sử khay đeo',
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
                              CaseProgress(order: order),
                              ListCaseProgressMobile(
                                  order: order, uid: uid, isShowFull: true),
                            ],
                          );
                        }
                        return const Row();
                      },
                    ),
                  ),
                );
              },
            )));
  }
}

class CaseProgress extends StatelessWidget {
  const CaseProgress({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    DateTime timeStart = dateFormat.parse(order.timeStart ?? "");

    Duration duration = DateTime.now().difference(timeStart);
    final count = (duration.inDays / 7 * (order.caseInWeek ?? 1)).floor();
    final percent = (count / order.totalCase!.toDouble()).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: TColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Đã đeo",
                      style: TextStyle(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  Text("$count / ${order.totalCase} khay",
                      style: const TextStyle(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ))
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 64,
                    percent: double.parse(percent),
                    lineHeight: 10,
                    barRadius: const Radius.circular(5),
                    padding: const EdgeInsets.all(0),
                    progressColor: TColors.secondary,
                    backgroundColor: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
