import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/icon_button.dart';
import 'package:venus/src/features/client/presentation/widget/group_button/button.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class GroupButton extends StatelessWidget {
  const GroupButton({super.key});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width > 1024 ? 468 : size.width,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageButton(
                    icon: "assets/images/aligner-icon.png",
                    path: "/aligners",
                    title: "Aligners",
                  ),
                  SizedBox(width: 24),
                  ImageButton(
                    icon: "assets/images/calendar-icon.png",
                    path: "/appointments",
                    title: "Appointments",
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ImageButton(
                    icon: "assets/images/gallery-icon.png",
                    path: "/wearings",
                    title: "Photos Wearing",
                  ),
                  const SizedBox(width: 24),
                  ImageButton(
                    icon: "assets/images/support-icon.png",
                    path: "",
                    onTap: () {
                      showDialog<Widget>(
                          context: context,
                          builder: (_) => BlocProvider.value(
                              value: context.read<AppBloc>(),
                              child: const SupportContactDialog()));
                    },
                    title: "Support Contact",
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class SupportContactDialog extends StatelessWidget {
  const SupportContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          final uid = context.read<AppBloc>().state.user.uid;
          final user = context.read<AppBloc>().state.user;

          return Center(
              child: Material(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: SizedBox(
                    height: 268,
                    width: size.width > 1024 ? 412 : size.width - 48,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 16, 24),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AIIconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          FutureBuilder(
                            future: CustomerRepository().getCustomer(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final customer = snapshot.data!;
                                return FutureBuilder(
                                  future: BranchRepository()
                                      .getBranch(customer.branchId ?? ""),
                                  builder: (context2, snapshot2) {
                                    if (snapshot2.connectionState ==
                                            ConnectionState.done &&
                                        snapshot2.hasData) {
                                      final branch = snapshot2.data!;
                                      return SizedBox(
                                        height: 186,
                                        width: 412,
                                        child: SingleChildScrollView(
                                          child: Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(branch.name ?? "",
                                                    style: TextStyle(
                                                        color:
                                                            HexColor("#DB1A20"),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                const Expanded(
                                                    flex: 4,
                                                    child: Text("Email: ")),
                                                Expanded(
                                                    flex: 8,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Uri mailto = Uri(
                                                          scheme: 'mailto',
                                                          path: branch.email ??
                                                              "",
                                                          queryParameters: {
                                                            'subject':
                                                                '${user.email}',
                                                            'body': ''
                                                          },
                                                        );
                                                        launchUrl(mailto);
                                                      },
                                                      child: Text(
                                                          branch.email ?? "",
                                                          style: TextStyle(
                                                            color: HexColor(
                                                                "#DB1A20"),
                                                          )),
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                const Expanded(
                                                    flex: 4,
                                                    child: Text("Phone: ")),
                                                Expanded(
                                                    flex: 8,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Uri phoneno = Uri.parse(
                                                            'tel:+${branch.phone?.substring(0, 10) ?? ""}');
                                                        launchUrl(phoneno);
                                                      },
                                                      child: Text(
                                                          branch.phone
                                                                  ?.substring(
                                                                      0, 10) ??
                                                              "",
                                                          style: TextStyle(
                                                            color: HexColor(
                                                                "#DB1A20"),
                                                          )),
                                                    )),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                const Text("Address: "),
                                                Text(
                                                  branch.address ?? "",
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ),
                                      );
                                    }
                                    return const SizedBox(width: 0);
                                  },
                                );
                              }
                              return const SizedBox(height: 48);
                            },
                          )
                        ]),
                      ),
                    ),
                  )));
        });
  }
}
