import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HeaderMobileUnlogin extends StatelessWidget
    implements PreferredSizeWidget {
  const HeaderMobileUnlogin({Key? key})
      : preferredSize = const Size.fromHeight(56),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 16,
        height: 56,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(image: AssetImage("assets/images/logos/logo-large.png"), width: 100, height: 32),
                    ElevatedButton(
                      onPressed: () {
                        context.go("/sign-in");
                      }, child: SvgPicture.asset("assets/icons/phone.svg")
                    ),
                  ],
                ),
              ],
            )));
  }

  @override
  final Size preferredSize;
}
