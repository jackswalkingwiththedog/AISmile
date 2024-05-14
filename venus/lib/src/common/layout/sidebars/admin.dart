import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/common/widgets/header.dart';
import 'package:venus/src/common/widgets/selection_button_widget.dart';

class AdminSideBar extends StatelessWidget {
  const AdminSideBar({
    Key? key,
    required this.page,
  }) : super(key: key);

  final String page;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        border: Border(
            right: BorderSide(
          color: Colors.black12,
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 8),
            child: LogoWidget(height: 40, width: 120),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                SelectionButton(
                  page: page,
                  data: [
                    SelectionButtonData(
                      activeIcon: EvaIcons.home,
                      icon: EvaIcons.homeOutline,
                      label: "Dental Clinic",
                      onPress: () {
                        context.go('/branch');
                      },
                      page: "branch",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.compass,
                      icon: EvaIcons.compassOutline,
                      label: "Admin",
                      onPress: () {
                        context.go('/admin');
                      },
                      page: "admin",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.grid,
                      icon: EvaIcons.gridOutline,
                      label: "Doctor",
                      onPress: () {
                        context.go('/doctor');
                      },
                      page: "doctor",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.archive,
                      icon: EvaIcons.archiveOutline,
                      label: "Order",
                      onPress: () {
                        context.go('/order');
                      },
                      page: "order",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: EvaIcons.personOutline,
                      label: "Customer",
                      onPress: () {
                        context.go('/customer');
                      },
                      page: "customer",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: EvaIcons.personOutline,
                      label: "Lead Designer",
                      onPress: () {
                        context.go('/lead-designer');
                      },
                      page: "lead-designer",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: EvaIcons.personOutline,
                      label: "Designer",
                      onPress: () {
                        context.go('/designer');
                      },
                      page: "designer",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: EvaIcons.personOutline,
                      label: "Reviewer",
                      onPress: () {
                        context.go('/reviewer');
                      },
                      page: "reviewer",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: EvaIcons.personOutline,
                      label: "Printer",
                      onPress: () {
                        context.go('/printer');
                      },
                      page: "printer",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.person,
                      icon: EvaIcons.personOutline,
                      label: "Shipper",
                      onPress: () {
                        context.go('/shipper');
                      },
                      page: "shipper",
                    ),
                  ],
                  onSelected: (index, value) {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
