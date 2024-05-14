import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_event.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/icon_button.dart';
import 'package:venus/src/features/client/presentation/widget/header/logo.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width > 1024 ? 1280 : size.width,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 24),
                  const Expanded(
                      flex: 4,
                      child: Row(
                        children: [Logo()],
                      )),
                  Expanded(
                      flex: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                context.go("/profile");
                              },
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(CircleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: HexColor("#DB1A20"))))),
                              child: CircleAvatar(
                                backgroundColor: HexColor("#DB1A20"),
                                radius: 18,
                                child: const Icon(Icons.person,
                                    color: Colors.white),
                              )),
                          BlocBuilder<AppBloc, AppState>(
                            builder: (context, state) {
                              return AIIconButton(
                                  onPressed: () async {
                                    context.go("/");
                                    context
                                        .read<AppBloc>()
                                        .add(const AppLogoutRequested());
                                  },
                                  icon: Icon(Icons.logout,
                                      color: HexColor("#DB1A20")));
                            },
                          ),
                        ],
                      )),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1)
            ],
          )),
    );
  }
}
