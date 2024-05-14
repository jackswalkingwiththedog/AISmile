import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/detail/detail_state.dart';
import 'package:venus/src/features/branch_employee/presentation/widgets/branch_employee_information.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';

class DetailDoctorScreen extends StatelessWidget {
  const DetailDoctorScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
        page: "doctor",
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
                  const Text('DETAIL DOCTOR',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  DetailDoctorView(id: id),
                ],
              ),
            )));
  }
}

class DetailDoctorView extends StatelessWidget {
  const DetailDoctorView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailBranchEmployeeCubit, DetailBranchEmployeeState>(
        listener: (context, state) {
          if (state.status == DetailBranchEmployeeStatus.error) {}
        },
        child: FutureBuilder(
          future: BranchEmployeeRepository().getBranchEmployee(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final employee = snapshot.data!;
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
                            BranchEmployeeInformation(
                                employee: employee,
                                role: "doctor",
                                title: "Doctor Information"),
                            const SizedBox(height: 24),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: DoctorBackButton(),
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

class DoctorBackButton extends StatelessWidget {
  const DoctorBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBranchEmployeeCubit, DetailBranchEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/doctor");
            },
            child: const Text('Back', style: TextStyle(color: Colors.black)),
          );
        });
  }
}
