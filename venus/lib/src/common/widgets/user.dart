import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_event.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/icon_button.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const UserButton(),
            AIIconButton(
                onPressed: () async {
                  context.go("/");
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
                icon: Icon(Icons.logout, color: HexColor("#80D32F2F"),))
          ],
        );
      },
    );
  }
}

class UserButton extends StatelessWidget {
  const UserButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 8),
              Text(
                user.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
