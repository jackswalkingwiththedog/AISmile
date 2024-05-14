import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:venus/src/services/firestore/entities/order.dart';

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

    final c = (order.caseInWeek ?? 1);
    var days = 7 ~/ c;
    var hours = (7 / c - (7 / c).floor()) * 24;
    var endDate = timeStart.add(
        Duration(days: days * (count + 1), hours: hours.toInt() * (count + 1)));
    var remainingTime = endDate.difference(DateTime.now());

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
            children: [
              Text(
                  textAlign: TextAlign.center,
                  "${remainingTime.inDays} Days - ${remainingTime.inHours % 24} Hours - ${remainingTime.inMinutes % 60} Minutes",
                  style: TextStyle(
                      color: HexColor("#DB1A20"),
                      fontSize: size.width > 1024 ? 20 : 16,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text(
                "to the next case",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("PROGRESS",
                      style: TextStyle(fontWeight: FontWeight.w900)),
                  Text("$count/${order.totalCase} CASE")
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                width: size.width > 1024 ? 420 : (size.width - 96),
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
