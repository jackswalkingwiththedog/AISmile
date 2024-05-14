import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/client/presentation/widget/aligner_table/aligner.dart';
import 'package:venus/src/features/client/presentation/widget/aligner_table/aligner_table.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/utils/constants/colors.dart';

class ListCaseProgressMobile extends StatelessWidget {
  const ListCaseProgressMobile(
      {super.key,
      required this.order,
      required this.uid,
      required this.isShowFull});

  final String uid;
  final AlignerOrder order;
  final bool isShowFull;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            isShowFull == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Lịch sử đeo khay",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      TextButton(
                          onPressed: () {
                            context.go("/aligners");
                          },
                          child: const Text("Xem thêm",
                              style: TextStyle(
                                color: TColors.primary,
                              ))),
                    ],
                  )
                : const Row(),
            const SizedBox(height: 16),
            ListCaseProgressView(order: order, isShowFull: isShowFull),
          ],
        ),
      ),
    );
  }
}

class ListCaseProgressView extends StatelessWidget {
  const ListCaseProgressView(
      {super.key, required this.order, required this.isShowFull});

  final AlignerOrder order;
  final bool isShowFull;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    DateTime timeStart = dateFormat.parse(order.timeStart ?? "");

    Duration duration = DateTime.now().difference(timeStart);

    final aligners = generateListAligners(
            length: (duration.inDays / 7 * (order.caseInWeek ?? 1)).floor(),
            start: timeStart,
            count: order.caseInWeek ?? 1)
        .reversed
        .toList();

    return SizedBox(
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: aligners.length > 2 && isShowFull == false
                ? 2
                : aligners.length,
            itemBuilder: (context, index) {
              return AlignerDetail(
                  aligner: aligners[index],
                  order: order,
                  length: aligners.length);
            },
          )
        ],
      ),
    );
  }
}

class AlignerDetail extends StatelessWidget {
  const AlignerDetail(
      {super.key,
      required this.aligner,
      required this.order,
      required this.length});

  final Aligner aligner;
  final AlignerOrder order;
  final int length;

  @override
  Widget build(BuildContext context) {
    final timeStart = aligner.startDate?.substring(6) ?? "";
    final timeEnd = aligner.endDate?.substring(6) ?? "";

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 104,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Material(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: TColors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8)),
          color: TColors.white,
          child: InkWell(
            onTap: () {
              showDialog<Widget>(
                  context: context,
                  useSafeArea: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      shadowColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      backgroundColor: Colors.white,
                      child: SingleChildScrollView(
                        child: AlignerDialog(
                            aligner: aligner, order: order, length: length),
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: TColors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset("assets/icons/loading.svg",
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                                TColors.black, BlendMode.srcIn))),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 136,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Khay ${aligner.id}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(aligner.id == length ? "Đang đeo" : "Xong",
                                style: TextStyle(
                                    color: aligner.id == length
                                        ? TColors.info
                                        : TColors.success,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("$timeStart - $timeEnd"),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlignerDialog extends StatelessWidget {
  const AlignerDialog(
      {super.key,
      required this.aligner,
      required this.order,
      required this.length});

  final Aligner aligner;
  final AlignerOrder order;
  final int length;

  @override
  Widget build(BuildContext context) {
    final end = DateFormat('HH:mm dd/MM/yyyy').parse(aligner.endDate ?? "");

    final remainingTime = end.difference(DateTime.now());
    final remainingTimeConverted =
        "${remainingTime.inDays} ngày ${remainingTime.inHours % 24} giờ nữa";

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    color:
                        length == aligner.id ? TColors.info : TColors.success,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: 32,
                        width: 108,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(length == aligner.id ? "Đang đeo" : "Xong",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Khay ${(aligner.id + 1).toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: TColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: SvgPicture.asset(
                                  "assets/icons/calendar.svg",
                                  height: 16,
                                  width: 16,
                                  colorFilter: const ColorFilter.mode(
                                      TColors.black, BlendMode.srcIn)),
                            )),
                        const SizedBox(width: 6),
                        Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: TColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                  "${aligner.startDate?.substring(6)}  -",
                                  style: const TextStyle(
                                      color: TColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            )),
                        const SizedBox(width: 8),
                        Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: TColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text("${aligner.endDate?.substring(6)}",
                                  style: const TextStyle(
                                      color: TColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          length == aligner.id
              ? Material(
                  color: TColors.primary.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: TColors.primary.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset("assets/icons/clock.svg",
                                  height: 16, width: 16),
                            )),
                        const SizedBox(width: 16),
                        Text(remainingTimeConverted,
                            style: const TextStyle(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                      ],
                    ),
                  ),
                )
              : const Row(),
        ],
      ),
    );
  }
}
