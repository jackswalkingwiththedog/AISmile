import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/common/widgets/header.dart';
import 'package:venus/src/common/widgets/selection_button_widget.dart';

class BranchDoctorSideBar extends StatelessWidget {
  const BranchDoctorSideBar({
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
          )
        ),
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
                      activeIcon: EvaIcons.grid,
                      icon: EvaIcons.gridOutline,
                      label: "Customer",
                      onPress: () {
                        context.go("/customer");
                      },
                      page: "customer",
                    ),
                    SelectionButtonData(
                      activeIcon: EvaIcons.calendar,
                      icon: EvaIcons.calendar,
                      label: "Appointment",
                      onPress: () {
                        context.go("/appointment");
                      },
                      page: "appointment",
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
