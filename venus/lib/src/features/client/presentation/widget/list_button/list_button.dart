import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/utils/constants/colors.dart';

class ListButtonMobile extends StatelessWidget {
  const ListButtonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 8),
          Text("Bạn đang muốn?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ImageButton(
              icon: "assets/images/icons/aligner.png",
              path: "/aligners",
              title: "Khay đeo",
            ),
            ImageButton(
              icon: "assets/images/icons/appointment.png",
              path: "/appointments",
              title: "Lịch hẹn",
            ),
            ImageButton(
              icon: "assets/images/icons/wearing.png",
              path: "/wearings",
              title: "Hình ảnh",
            )
          ])
        ]),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  const ImageButton(
      {super.key, required this.icon, required this.path, required this.title});

  final String icon;
  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            style: ButtonStyle(
                side: MaterialStatePropertyAll(
                    BorderSide(color: TColors.black.withOpacity(0.1))),
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.fromLTRB(32, 24, 32, 24))),
            onPressed: () {
              context.go(path);
            },
            child: Image.asset(
              icon,
              height: 34,
              width: 34,
            )),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.titleSmall)
      ],
    );
  }
}
