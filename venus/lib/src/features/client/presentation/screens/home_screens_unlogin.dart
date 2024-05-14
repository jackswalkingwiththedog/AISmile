import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/features/client/presentation/widget/header_mobile_unlogin/header_mobile_unlogin.dart';
import 'package:venus/src/features/client/presentation/widget/list_button/list_button.dart';
import 'package:venus/src/features/client/presentation/widget/list_video_mobile/list_video_mobile.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/constants/sizes.dart';
import 'package:venus/src/utils/theme/custom_themes/text_theme.dart';

class HomeScreenMobileUnAuthentiated extends StatelessWidget {
  const HomeScreenMobileUnAuthentiated({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.go('/');
      },
      child: CustomScaffold(
        appBar: CustomAppBar(
          actions: const [HeaderMobileUnlogin()],
        ),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Material(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    color: TColors.primary,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Xin chào,",
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                    color: TColors.white.withOpacity(0.7))),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                    flex: 8,
                                    child: Text(
                                        "Đăng nhập ngay để quản lý khay đeo của bạn",
                                        style: TTextTheme
                                            .darkTextTheme.bodyMedium)),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                Expanded(
                                  flex: 4,
                                  child: ElevatedButton(
                                      style: const ButtonStyle(
                                          padding: MaterialStatePropertyAll(
                                              EdgeInsets.all(4)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              24)))),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  TColors.white)),
                                      onPressed: () {
                                        context.go("/sign-in");
                                      },
                                      child: const Text("Đăng nhập",
                                          style: TextStyle(
                                            color: TColors.black,
                                          ))),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const ListButtonMobileUnlogin(),
                  const ListVideoMobile(),
                ],
              ),
            )),
      ),
    );
  }
}

class ListButtonMobileUnlogin extends StatelessWidget {
  const ListButtonMobileUnlogin({super.key});

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
              path: "/sign-in",
              title: "Khay đeo",
            ),
            ImageButton(
              icon: "assets/images/icons/appointment.png",
              path: "/sign-in",
              title: "Lịch hẹn",
            ),
            ImageButton(
              icon: "assets/images/icons/wearing.png",
              path: "/sign-in",
              title: "Hình ảnh",
            )
          ])
        ]),
      ),
    );
  }
}
