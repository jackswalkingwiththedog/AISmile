import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:venus/src/features/client/presentation/widget/list_video_mobile/list_video_mobile.dart';
import 'package:venus/src/services/firestore/entities/appointment.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';

class AppointmentDetailMobile extends StatelessWidget {
  const AppointmentDetailMobile({
    super.key,
    required this.branch,
    required this.doctor,
    required this.appointment,
    required this.navigate,
  });

  final Branch branch;
  final BranchEmployee doctor;
  final MyAppointment appointment;
  final String navigate;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (pop) {
          if (!pop) {
            Navigator.pop(context);
          } else {
            context.go(navigate);
          }
        },
        child: CustomScaffold(
            appBar: CustomAppBar(
              title: 'Lịch hẹn chi tiết',
              centerTitle: true,
              onGoBack: () {
                Navigator.pop(context);
              },
            ),
            body: Padding(
                padding: const EdgeInsets.all(0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              AppointmentDetailView(
                                  branch: branch,
                                  doctor: doctor,
                                  appointment: appointment),
                              const ListVideoMobile()
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          TColors.primary),
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.all(16)),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)))),
                              onPressed: () {
                                Uri phoneno = Uri.parse(
                                    'tel:+${branch.phone?.substring(0, 10) ?? ""}');
                                launchUrl(phoneno);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/phone.svg"),
                                  const SizedBox(width: 4),
                                  const Text("Liên lạc với phòng khám",
                                      style: TextStyle(color: Colors.white))
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ))));
  }
}

class AppointmentDetailView extends StatelessWidget {
  const AppointmentDetailView(
      {super.key,
      required this.branch,
      required this.doctor,
      required this.appointment});

  final Branch branch;
  final MyAppointment appointment;
  final BranchEmployee doctor;

  @override
  Widget build(BuildContext context) {
    final hourStart = appointment.startTime?.substring(0, 6) ?? "";
    final hourEnd = appointment.endTime?.substring(0, 6) ?? "";

    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    final startTime = dateFormat.parse(appointment.startTime ?? "");

    final duration = DateTime.now().difference(startTime).inMicroseconds;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Material(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: TColors.black.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(8)),
            color: TColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        child: Image.asset(
                          "assets/images/icons/doctor.png",
                          width: 38,
                          height: 38,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor.name ?? "",
                              style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 124,
                            child: Text(appointment.notes ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: TColors.black.withOpacity(0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: duration <= 0
                            ? TColors.primary.withOpacity(0.3)
                            : TColors.grey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/icons/calendar.svg",
                                  height: 16,
                                  width: 16,
                                  colorFilter: ColorFilter.mode(
                                      duration <= 0
                                          ? TColors.primary
                                          : TColors.black,
                                      BlendMode.srcIn)),
                              const SizedBox(width: 6),
                              Text(appointment.startTime?.substring(7) ?? "",
                                  style: TextStyle(
                                      color: duration <= 0
                                          ? TColors.primary
                                          : TColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: duration <= 0
                            ? TColors.primary.withOpacity(0.3)
                            : TColors.grey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/icons/clock.svg",
                                  height: 16,
                                  width: 16,
                                  colorFilter: ColorFilter.mode(
                                      duration <= 0
                                          ? TColors.primary
                                          : TColors.black,
                                      BlendMode.srcIn)),
                              const SizedBox(width: 6),
                              Text("$hourStart - $hourEnd",
                                  style: TextStyle(
                                      color: duration <= 0
                                          ? TColors.primary
                                          : TColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.subject ?? "",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      const Text("Địa chỉ: ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(appointment.location ?? ""),
                      const SizedBox(height: 16),
                      const Text("Ghi chú:",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(appointment.notes ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                          )),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
