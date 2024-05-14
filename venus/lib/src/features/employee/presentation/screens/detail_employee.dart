import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/common/layout/dashboard_layout.dart';
import 'package:venus/src/features/employee/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/employee/presentation/blocs/detail/detail_state.dart';
import 'package:venus/src/features/employee/presentation/widgets/employee_information.dart';
import 'package:venus/src/services/firestore/repository/employee_repository.dart';

class DetailEmployeeScreen extends StatelessWidget {
  const DetailEmployeeScreen({super.key, required this.id, required this.role});

  final String id;
  final String role;

  @override
  Widget build(BuildContext context) {
    var text = "";
    if (role == "lead-designer") {
      text = "Lead Designer";
    }
    if (role == "designer") {
      text = "Designer";
    }
    if (role == "reviewer") {
      text = "Reviewer";
    }
    if (role == "printer") {
      text = "Printer";
    }
    if (role == "shipper") {
      text = "Shipper";
    }

    return DashboardLayout(
        page: role,
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
                  Text('DETAIL ${role.toUpperCase()}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 24),
                  DetailEmployeeView(id: id, role: role, text: text),
                ],
              ),
            )));
  }
}

class DetailEmployeeView extends StatelessWidget {
  const DetailEmployeeView(
      {Key? key, required this.id, required this.role, required this.text})
      : super(key: key);

  final String id;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailEmployeeCubit, DetailEmployeeState>(
        listener: (context, state) {
          if (state.status == DetailEmployeeStatus.error) {}
        },
        child: FutureBuilder(
          future: EmployeeRepository().getEmployee(id),
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
                            EmployeeInformation(
                                employee: employee,
                                role: role,
                                title: "$text Information",
                                text: text),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  child: EmployeeBackButton(role: role),
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

class EmployeeBackButton extends StatelessWidget {
  const EmployeeBackButton({Key? key, required this.role}) : super(key: key);

  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailEmployeeCubit, DetailEmployeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return OutlinedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () {
              context.go("/$role");
            },
            child: const Text('Back', style: TextStyle(color: Colors.black)),
          );
        });
  }
}
