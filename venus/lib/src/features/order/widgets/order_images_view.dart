import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/services/firestore/entities/order.dart';

class OrderImagesView extends StatelessWidget {
  const OrderImagesView({super.key, required this.order});

  final AlignerOrder order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 524 + 168,
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("LIST IMAGES SCANS",
                  style: TextStyle(color: HexColor("#DB1A20"), fontSize: 16)),
              const SizedBox(height: 24),
              SizedBox(
                  height: 524,
                  width: 568,
                  child: Material(
                    child: GridView.builder(
                        itemCount: order.images?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          crossAxisCount: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Material(
                            child: Row(children: [
                              Image.network(order.images?[index] ?? "",
                                  height: 524, width: 568)
                            ]),
                          );
                        }),
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: 568,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AIButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close",
                            style: TextStyle(color: Colors.white)))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
