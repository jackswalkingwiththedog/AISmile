import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:venus/src/services/firestore/entities/wearing.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_scaffold.dart';
import 'package:venus/src/utils/constants/colors.dart';

class ListWearingMobile extends StatelessWidget {
  const ListWearingMobile({super.key, required this.wearings});

  final List<Wearing> wearings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: wearings.length,
              itemBuilder: (context, index) {
                return WearingDetail(wearing: wearings[index]);
              },
            )
          ],
        ),
      ),
    );
  }
}

class WearingDetail extends StatelessWidget {
  const WearingDetail({super.key, required this.wearing});

  final Wearing wearing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Material(
            color: TColors.white,
            child: InkWell(
              onTap: () {
                showDialog<Widget>(
                    context: context,
                    useSafeArea: false,
                    builder: (BuildContext context) {
                      return WearingDetailMobile(wearing: wearing);
                    });
              },
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: TColors.grey,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/calendar.svg",
                                            height: 16,
                                            width: 16,
                                            colorFilter: const ColorFilter.mode(
                                                TColors.black,
                                                BlendMode.srcIn)),
                                        const SizedBox(width: 6),
                                        Text(
                                            wearing.createTime?.substring(6) ??
                                                "",
                                            style: const TextStyle(
                                                color: TColors.black,
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
                                  color: TColors.grey,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/clock.svg",
                                            height: 16,
                                            width: 16,
                                            colorFilter: const ColorFilter.mode(
                                                TColors.black,
                                                BlendMode.srcIn)),
                                        const SizedBox(width: 6),
                                        Text(
                                            wearing.createTime
                                                    ?.substring(0, 6) ??
                                                "",
                                            style: const TextStyle(
                                                color: TColors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(wearing.note ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: wearing.images![0],
                                placeholder: (context, url) => Material(
                                  color: Colors.black12,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width + 32,
                                    height: (MediaQuery.of(context).size.width +
                                            32) *
                                        9 /
                                        16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: TColors.black.withOpacity(0.1),
                        thickness: 16,
                      )
                    ],
                  )),
            ),
          ),
        ));
  }
}

class WearingDetailMobile extends StatelessWidget {
  const WearingDetailMobile({super.key, required this.wearing});

  final Wearing wearing;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: CustomScaffold(
        appBar: CustomAppBar(
          title: 'Hình ảnh',
          centerTitle: true,
          onGoBack: () {
            Navigator.pop(context);
          },
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              color: TColors.grey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/calendar.svg",
                                        height: 16,
                                        width: 16,
                                        colorFilter: const ColorFilter.mode(
                                            TColors.black, BlendMode.srcIn)),
                                    const SizedBox(width: 6),
                                    Text(wearing.createTime?.substring(6) ?? "",
                                        style: const TextStyle(
                                            color: TColors.black,
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
                              color: TColors.grey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/clock.svg",
                                        height: 16,
                                        width: 16,
                                        colorFilter: const ColorFilter.mode(
                                            TColors.black, BlendMode.srcIn)),
                                    const SizedBox(width: 6),
                                    Text(
                                        wearing.createTime?.substring(0, 6) ??
                                            "",
                                        style: const TextStyle(
                                            color: TColors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(wearing.note ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                            )),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wearing.images!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: wearing.images![index],
                            placeholder: (context, url) => Material(
                              color: Colors.black12,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width + 32,
                                height:
                                    (MediaQuery.of(context).size.width + 32) *
                                        9 /
                                        16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
