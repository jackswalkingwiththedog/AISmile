import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/common/components/button.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/branch/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/branch/presentation/blocs/detail/detail_state.dart';
import 'package:venus/src/features/branch/presentation/widgets/branch_information.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';
import 'package:venus/src/services/firestore/repository/branch_repository.dart';

class DetailBranchScreen extends StatelessWidget {
  const DetailBranchScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "branch",
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 65,
            color: const Color(0xFFFAFAFA),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DETAIL DENTAL CLINIC',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  DetailBranchView(id: id),
                ],
              ),
            )));
  }
}

class DetailBranchView extends StatelessWidget {
  const DetailBranchView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailBranchCubit, DetailBranchState>(
        listener: (context, state) {
          if (state.status == DetailBranchStatus.error) {}
        },
        child: FutureBuilder(
          future: BranchRepository().getBranch(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final branch = snapshot.data!;
              return Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 168,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CreateDoctorButton(id: id),
                                const SizedBox(width: 16),
                                CreateAdminButton(id: id)
                              ],
                            ),
                            const SizedBox(height: 24),
                            BranchInformation(branch: branch),
                            const SizedBox(height: 24),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: BranchBackButton(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class BranchEditButton extends StatelessWidget {
  const BranchEditButton({Key? key, required this.branch}) : super(key: key);

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBranchCubit, DetailBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return AIButton(
            onPressed: () {
              context.go("/branch/edit/${branch.id}");
            },
            icon: Icons.edit,
            child: state.status == DetailBranchStatus.submitting
                ? const ProgressIcon(color: Colors.white)
                : const Text('Update'),
          );
        });
  }
}

class BranchCancelButton extends StatelessWidget {
  const BranchCancelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBranchCubit, DetailBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
              )
            ),
            onPressed: () {
              context.go("/branch");
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          );
        });
  }
}

class CreateDoctorButton extends StatelessWidget {
  const CreateDoctorButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-doctor/$id");
      },
      icon: Icons.add,
      child: const Text('Add Doctor', style: TextStyle(
        color: Colors.white
      )),
    );
  }
}

class CreateAdminButton extends StatelessWidget {
  const CreateAdminButton({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return AIButton(
      onPressed: () {
        context.go("/create-admin/$id");
      },
      icon: Icons.add,
      child: const Text('Add Admin', style: TextStyle(
        color: Colors.white
      )),
    );
  }
}

class ValueField extends StatelessWidget {
  const ValueField({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Text(value),
        const SizedBox(height: 16),
      ],
    );
  }
}

class BranchBackButton extends StatelessWidget {
  const BranchBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBranchCubit, DetailBranchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
              )
            ),
            onPressed: () {
              context.go("/branch");
            },
            child: const Text('Back', style: TextStyle(color: Colors.black)),
          );
        });
  }
}
