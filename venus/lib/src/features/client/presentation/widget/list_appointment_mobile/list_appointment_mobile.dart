import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/client/presentation/widget/appointment_detail_mobile/appointment_detail_mobile.dart';
import 'package:venus/src/services/firestore/entities/appointment.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/appointment_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class ListAppointmentMobile extends StatelessWidget {
  const ListAppointmentMobile(
      {super.key,
      required this.order,
      required this.uid,
      required this.navigate,
      required this.isShowFull});

  final String uid;
  final AlignerOrder order;
  final bool isShowFull;
  final String navigate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isShowFull == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Cuộc hẹn",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      TextButton(
                          onPressed: () {
                            context.go("/appointments");
                          },
                          child: const Text("Xem thêm"))
                    ],
                  )
                : const Row(),
            const SizedBox(height: 16),
            FutureBuilder(
              future: AppointmentRepository().listAppointment(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final appointments = snapshot.data!.where((element) {
                    if (element.customerId == uid) {
                      return true;
                    }
                    return false;
                  }).toList();

                  appointments.sort((a, b) {
                    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
                    final timeA = dateFormat.parse(a.startTime ?? "");
                    final timeB = dateFormat.parse(b.startTime ?? "");
                    Duration durationA = DateTime.now().difference(timeA);
                    Duration durationB = DateTime.now().difference(timeB);
                    return durationA.inMinutes.compareTo(durationB.inMinutes);
                  });

                  return SizedBox(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              appointments.length > 1 && isShowFull == false
                                  ? 1
                                  : appointments.length,
                          itemBuilder: (context, index) {
                            return AppointmentDetail(
                                navigate: navigate,
                                appointment: appointments[index]);
                          },
                        )
                      ],
                    ),
                  );
                }
                return SizedBox(
                    child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: isShowFull ? 4 : 2,
                      itemBuilder: (context, index) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Material(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: TColors.black.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(8)),
                                color: TColors.white,
                              ),
                            ));
                      },
                    )
                  ],
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentDetail extends StatelessWidget {
  const AppointmentDetail(
      {super.key, required this.appointment, required this.navigate});

  final MyAppointment appointment;
  final String navigate;

  @override
  Widget build(BuildContext context) {
    final hourStart = appointment.startTime?.substring(0, 6) ?? "";
    final hourEnd = appointment.endTime?.substring(0, 6) ?? "";

    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    final startTime = dateFormat.parse(appointment.startTime ?? "");

    final duration = DateTime.now().difference(startTime).inMicroseconds;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 140,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: FutureBuilder(
            future: BranchEmployeeRepository()
                .getBranchEmployee(appointment.doctorId ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final doctor = snapshot.data!;
                return FutureBuilder(
                  future: BranchRepository().getBranch(doctor.branchId),
                  builder: (context2, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.done &&
                        snapshot2.hasData) {
                      final branch = snapshot2.data!;
                      return Material(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: TColors.black.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(8)),
                        color: TColors.white,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AppointmentDetailMobile(
                                        branch: branch,
                                        doctor: doctor,
                                        appointment: appointment,
                                        navigate: navigate,
                                      )));
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(24)),
                                          child: Image.asset(
                                              "assets/images/icons/doctor.png",
                                              width: 38,
                                              height: 38),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(doctor.name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  124,
                                              child: Text(
                                                  appointment.notes ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: TColors.black
                                                          .withOpacity(0.7),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          color: duration <= 0
                                              ? TColors.primary.withOpacity(0.3)
                                              : TColors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 6, 12, 6),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icons/calendar.svg",
                                                    height: 16,
                                                    width: 16,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            duration <= 0
                                                                ? TColors
                                                                    .primary
                                                                : TColors.black,
                                                            BlendMode.srcIn)),
                                                const SizedBox(width: 6),
                                                Text(
                                                    appointment.startTime
                                                            ?.substring(6) ??
                                                        "",
                                                    style: TextStyle(
                                                        color: duration <= 0
                                                            ? TColors.primary
                                                            : TColors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600))
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          color: duration <= 0
                                              ? TColors.primary.withOpacity(0.3)
                                              : TColors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 6, 12, 6),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/clock.svg",
                                                  height: 16,
                                                  width: 16,
                                                  colorFilter: ColorFilter.mode(
                                                      duration <= 0
                                                          ? TColors.primary
                                                          : TColors.black,
                                                      BlendMode.srcIn),
                                                ),
                                                const SizedBox(width: 6),
                                                Text("$hourStart - $hourEnd",
                                                    style: TextStyle(
                                                        color: duration <= 0
                                                            ? TColors.primary
                                                            : TColors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600))
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    }
                    return const SizedBox(width: 0);
                  },
                );
              }
              return const Row();
            },
          )),
    );
  }
}
