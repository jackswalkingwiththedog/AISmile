import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/services/firestore/entities/wearing.dart';

class WearingView extends StatelessWidget {
  const WearingView({super.key, required this.wearing});

  final Wearing wearing;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width > 1024 ? 568 : size.width,
      height: size.width > 1024 ? 568 : size.height - 96,
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("LIST WEARING",
                  style: TextStyle(color: HexColor("#DB1A20"), fontSize: 16)),
              const SizedBox(height: 24),
              SizedBox(
                  height: size.width > 1024 ? 568 : size.width,
                  width: size.width > 1024 ? 568 : size.width,
                  child: Material(
                    child: GridView.builder(
                        itemCount: wearing.images?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          crossAxisCount: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Material(
                            child: Row(children: [
                              Image.network(wearing.images?[index] ?? "",
                                  height:
                                      size.width > 1024 ? 568 : size.width - 128,
                                  width:
                                      size.width > 1024 ? 568 : size.width - 128)
                            ]),
                          );
                        }),
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: size.width > 1024 ? 568 : size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AIButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            fixedSize:
                                const MaterialStatePropertyAll(Size(86, 40)),
                            backgroundColor:
                                MaterialStatePropertyAll(HexColor("#DB1A20"))),
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
