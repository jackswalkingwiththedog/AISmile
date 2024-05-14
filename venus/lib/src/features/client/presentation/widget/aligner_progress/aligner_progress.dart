import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:venus/src/services/firestore/entities/order.dart';

class AlignerProgress extends StatelessWidget {
  const AlignerProgress({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    DateTime timeStart = dateFormat.parse(order.timeStart ?? "");

    Duration duration = DateTime.now().difference(timeStart);

    final count = (duration.inDays / 7 * (order.caseInWeek ?? 1)).floor();
    final percent = (count / order.totalCase!.toDouble()).toStringAsFixed(2);

    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: 468,
      child: Material(
        shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            side: BorderSide(
              color: HexColor("#DB1A20"),
              width: 1,
            )),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("START DATE : ${order.timeStart}",
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  size.width > 1024
                      ? Text("$count/${order.totalCase} CASE")
                      : const SizedBox(width: 0)
                ],
              ),
              const SizedBox(height: 16),
              size.width > 1024 ? const SizedBox(width: 0) : Text("$count/${order.totalCase} CASE"),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                width: size.width > 1024 ? 420 : size.width - 96,
                percent: double.parse(percent),
                lineHeight: 8,
                padding: const EdgeInsets.all(0),
                progressColor: HexColor("#DB1A20"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
