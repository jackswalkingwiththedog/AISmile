import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class HeaderMobile extends StatelessWidget implements PreferredSizeWidget {
  const HeaderMobile({Key? key, required this.uid})
      : preferredSize = const Size.fromHeight(56),
        super(key: key);

  final String uid;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 16,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(
                    image: AssetImage("assets/images/logos/logo-large.png"),
                    width: 100,
                    height: 32),
                FutureBuilder(
                  future: CustomerRepository().getCustomer(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final customer = snapshot.data!;
                      return FutureBuilder(
                        future: BranchRepository()
                            .getBranch(customer.branchId ?? ""),
                        builder: (context2, snapshot2) {
                          if (snapshot2.connectionState ==
                                  ConnectionState.done &&
                              snapshot2.hasData) {
                            final branch = snapshot2.data!;
                            return ElevatedButton(
                                onPressed: () {
                                  Uri phoneno = Uri.parse(
                                      'tel:+${branch.phone?.substring(0, 10) ?? ""}');
                                  launchUrl(phoneno);
                                },
                                child:
                                    SvgPicture.asset("assets/icons/phone.svg"));
                          }
                          return const SizedBox(width: 0);
                        },
                      );
                    }
                    return const SizedBox(height: 56);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
