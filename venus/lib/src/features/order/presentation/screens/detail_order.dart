import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/customer/presentation/widgets/customer_information.dart';
import 'package:venus/src/features/order/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/detail/detail_state.dart';
import 'package:venus/src/features/order/widgets/order_information.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/services/firestore/repository/order_repository.dart';

class DetailOrderScreen extends StatelessWidget {
  const DetailOrderScreen({super.key, required this.id});

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
                  const Text('DETAIL ORDER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  DetailOrderView(id: id),
                ],
              ),
            )));
  }
}

class DetailOrderView extends StatelessWidget {
  const DetailOrderView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailOrderCubit, DetailOrderState>(
      listener: (context, state) {
        if (state.status == DetailOrderStatus.error) {}
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
                  child: BlocBuilder<AppBloc, AppState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        final role = context.read<AppBloc>().state.role;
                        return FutureBuilder(
                          future: AlignerOrderRepository().getAlignerOrder(id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final order = snapshot.data!;
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      EditOrderButton(id: order.id),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  role == Role.shipper
                                      ? FutureBuilder(
                                          future: CustomerRepository()
                                              .getCustomer(order.customerId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.done &&
                                                snapshot.hasData) {
                                              final customer = snapshot.data!;
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    flex: 12,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text("FROM:"),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text("AISMILE",
                                                                style: TextStyle(
                                                                    color: HexColor(
                                                                        "#DB1A20"))),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        FutureBuilder(
                                                          future: BranchEmployeeRepository()
                                                              .getBranchEmployee(
                                                                  customer.doctorId ??
                                                                      ""),
                                                          builder: (context2,
                                                              snapshot2) {
                                                            if (snapshot2
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .done &&
                                                                snapshot2
                                                                    .hasData) {
                                                              final doctor =
                                                                  snapshot2
                                                                      .data!;
                                                              return Row(
                                                                children: [
                                                                  const Text(
                                                                      "TO: "),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                      "Doctor ${doctor.name}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              HexColor("#DB1A20"))),
                                                                ],
                                                              );
                                                            }
                                                            return const SizedBox(
                                                                width: 0);
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        FutureBuilder(
                                                          future: BranchRepository()
                                                              .getBranch(customer
                                                                      .branchId ??
                                                                  ""),
                                                          builder: (context2,
                                                              snapshot2) {
                                                            if (snapshot2
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .done &&
                                                                snapshot2
                                                                    .hasData) {
                                                              final branch =
                                                                  snapshot2
                                                                      .data!;
                                                              return Row(
                                                                children: [
                                                                  const Text(
                                                                      "ADDRESS: "),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                      "${branch.address}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              HexColor("#DB1A20"))),
                                                                  const SizedBox(
                                                                      width:
                                                                          24),
                                                                  const Text(
                                                                      "PHONE: "),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                      "${branch.phone}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              HexColor("#DB1A20"))),
                                                                ],
                                                              );
                                                            }
                                                            return const SizedBox(
                                                                width: 0);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        )
                                      : const SizedBox(width: 0)
                                ],
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                      })),
            ),
          )),
    );
  }
}

class EditOrderButton extends StatelessWidget {
  const EditOrderButton({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/order/edit/$id");
      },
      icon: Icons.add,
      child: const Text('UPDATE', style: TextStyle(color: Colors.white)),
    );
  }
}
