import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:venus/src/services/firebase_authentication/entities/firebase_user.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/utils/constants/colors.dart';

class CaseProgressMobile extends StatelessWidget {
  const CaseProgressMobile(
      {super.key,
      required this.order,
      required this.user,
      required this.customer});

  final AlignerOrder order;
  final FirebaseUser user;
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  context.go("/profile");
                },
                child: customer.avatar == ""
                    ? const SizedBox(
                        height: 108,
                        width: 108,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: Icon(Icons.person,
                              color: TColors.primary, size: 40),
                        ),
                      )
                    : SizedBox(
                        height: 108,
                        width: 108,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                              image: NetworkImage(customer.avatar ?? ""),
                              fit: BoxFit.cover,
                              height: 108,
                              width: 108),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(customer.name ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  CaseProgressDetailMobile(order: order)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CaseProgressDetailMobile extends StatelessWidget {
  const CaseProgressDetailMobile({super.key, required this.order});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Kế tiếp: ",
                style: TextStyle(color: TColors.white.withOpacity(0.7)),
                textAlign: TextAlign.start),
            Text(
                textAlign: TextAlign.center,
                "${remainingTime.inDays} ngày ${remainingTime.inHours % 24} giờ nữa",
                style: TextStyle(
                  color: TColors.white.withOpacity(0.7),
                  fontSize: 14,
                )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            LinearPercentIndicator(
              width: 120,
              percent: double.parse(percent),
              lineHeight: 10,
              padding: const EdgeInsets.all(0),
              progressColor: TColors.secondary,
              backgroundColor: TColors.white,
              barRadius: const Radius.circular(5),
            ),
            const SizedBox(width: 16),
            Text("$count/${order.totalCase} khay",
                style: const TextStyle(color: TColors.white, fontSize: 14))
          ],
        )
      ],
    );
  }
}
