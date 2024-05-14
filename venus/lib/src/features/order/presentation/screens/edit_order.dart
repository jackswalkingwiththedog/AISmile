import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/customer/presentation/widgets/customer_information.dart';
import 'package:venus/src/features/order/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/features/order/widgets/approve_action.dart';
import 'package:venus/src/features/order/widgets/assign_designer.dart';
import 'package:venus/src/features/order/widgets/designer_action.dart';
import 'package:venus/src/features/order/widgets/doctor_action.dart';
import 'package:venus/src/features/order/widgets/order_information.dart';
import 'package:venus/src/features/order/widgets/print_action.dart';
import 'package:venus/src/features/order/widgets/reviewer_action.dart';
import 'package:venus/src/features/order/widgets/ship_action.dart';
import 'package:venus/src/features/order/widgets/wearing_action.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';

class EditOrderScreen extends StatelessWidget {
  const EditOrderScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "order",
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
                  const Text('EDIT ORDER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  EditOrderView(id: id),
                ],
              ),
            )));
  }
}

class EditOrderView extends StatelessWidget {
  const EditOrderView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditOrderCubit, EditOrderState>(
      listener: (context, state) {
        if (state.status == EditOrderStatus.error) {}
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
                child: FutureBuilder(
                  future: AlignerOrderRepository().getAlignerOrder(id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final order = snapshot.data!;
                      return BlocBuilder<AppBloc, AppState>(
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, state) {
                            final role = context.read<AppBloc>().state.role;
                            final uid = context.read<AppBloc>().state.user.uid;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (order.status == "submit" ||
                                                order.status == "assigned") &&
                                            (role == Role.leadDesigner)
                                        ? SubmitAssignDesigner(
                                            order: order, role: role, uid: uid)
                                        : const Row(),
                                    ((order.status == "assigned" ||
                                                order.status == "designing" ||
                                                order.status == "rejected") &&
                                            role == Role.designer)
                                        ? SubmitDesignerAction(
                                            order: order, role: role, uid: uid)
                                        : const Row(),
                                    order.status == "waiting review" &&
                                            role == Role.reviewer
                                        ? SubmitReviewerAction(
                                            order: order, role: role, uid: uid)
                                        : const Row(),
                                    order.status == "waiting approve" &&
                                            role == Role.branchDoctor
                                        ? SubmitApproveAction(
                                            order: order, role: role, uid: uid)
                                        : const Row(),
                                    (order.status == "waiting print" ||
                                                order.status == "printing") &&
                                            role == Role.printer
                                        ? SubmitPrintAction(
                                            order: order, role: role, uid: uid)
                                        : const Row(),
                                    (order.status == "waiting ship" ||
                                                order.status ==
                                                    "receive order" ||
                                                order.status == "delivering") &&
                                            role == Role.shipper
                                        ? SubmitShipAction(
                                            order: order, role: role, uid: uid)
                                        : const Row(),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('CREATE AT: '),
                                    const SizedBox(width: 8),
                                    Text(order.createAt ?? "",
                                        style: TextStyle(
                                            color: HexColor("#DB1A20"))),
                                    const SizedBox(width: 24),
                                    const Text('STATUS: '),
                                    const SizedBox(width: 8),
                                    Text(order.status?.toUpperCase() ?? "",
                                        style: TextStyle(
                                            color: HexColor("#DB1A20"))),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Start Lead Designer Action
                                (order.status == "submit" ||
                                            order.status == "assigned") &&
                                        (role == Role.leadDesigner)
                                    ? AssignDesignerWidget(order: order)
                                    : const Row(),
                                // End Lead Designer Action

                                // Start Designer Action
                                (order.status == "assigned" ||
                                            order.status == "designing" ||
                                            order.status == "rejected") &&
                                        role == Role.designer
                                    ? DesignerActionWidget(order: order)
                                    : const Row(),
                                // End Designer Action

                                // Start Reviewer Action
                                (order.status == "waiting review") &&
                                        role == Role.reviewer
                                    ? ReviewerActionWidget(order: order)
                                    : const Row(),
                                // End Reviewer Action

                                // Start Doctor Action
                                (order.status == "waiting approve") &&
                                        role == Role.branchDoctor
                                    ? ApproveActionWidget(order: order)
                                    : const Row(),
                                // End Doctor Action

                                // Start Printer Action
                                (order.status == "waiting print" ||
                                            order.status == "printing") &&
                                        role == Role.printer
                                    ? PrintActionWidget(order: order)
                                    : const Row(),
                                // End Printer Action

                                // Start Printer Action
                                (order.status == "waiting ship" ||
                                            order.status == "receive order" ||
                                            order.status == "delivering") &&
                                        role == Role.shipper
                                    ? ShipActionWidget(order: order)
                                    : const Row(),
                                // End Printer Action

                                // Start Wearing Action
                                (order.status == "done" ||
                                            order.status == "wearing") &&
                                        role == Role.branchDoctor
                                    ? WearingActionWidget(order: order)
                                    : const Row(),
                                // End Wearing Action

                                (role == Role.branchDoctor)
                                    ? DoctorActionWidget(order: order)
                                    : const Row(),

                                const SizedBox(height: 24),
                                role == Role.shipper
                                    ? const SizedBox(width: 0)
                                    : FutureBuilder(
                                        future: CustomerRepository()
                                            .getCustomer(order.customerId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            final customer = snapshot.data!;
                                            return CustomerInformation(
                                                customer: customer);
                                          }
                                          return const Row();
                                        },
                                      ),
                                role == Role.shipper
                                    ? const SizedBox(width: 0)
                                    : const SizedBox(height: 24),
                                role == Role.shipper
                                    ? const SizedBox(width: 0)
                                    : OrderInformation(order: order),
                              ],
                            );
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          )),
    );
  }
}
