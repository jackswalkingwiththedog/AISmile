import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:venus/src/app/bloc/app_bloc.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/features/appointment/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/appointment/presentation/screens/create_appointment.dart';
import 'package:venus/src/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:venus/src/features/authentication/presentation/screens/signin_screen.dart';
import 'package:venus/src/features/branch/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/branch/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/branch/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/branch/presentation/screens/create_screen.dart';
import 'package:venus/src/features/branch/presentation/screens/detail_screen.dart';
import 'package:venus/src/features/branch/presentation/screens/edit_screen.dart';
import 'package:venus/src/features/branch/presentation/screens/list_screen.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/create_admin.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/create_doctor.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/detail_admin.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/detail_doctor.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/edit_admin.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/edit_doctor.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/list_admin.dart';
import 'package:venus/src/features/branch_employee/presentation/screens/list_doctor.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_cubit.dart';
import 'package:venus/src/features/client/presentation/screens/aligner_screens.dart';
import 'package:venus/src/features/client/presentation/screens/appointment_screens.dart';
import 'package:venus/src/features/client/presentation/screens/edit_profile_screens.dart';
import 'package:venus/src/features/client/presentation/screens/home_screens.dart';
import 'package:venus/src/features/client/presentation/screens/home_screens_unlogin.dart';
import 'package:venus/src/features/client/presentation/screens/profile_screens.dart';
import 'package:venus/src/features/client/presentation/screens/wearing_screens.dart';
import 'package:venus/src/features/customer/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/customer/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/customer/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/customer/presentation/screens/create_customer.dart';
import 'package:venus/src/features/customer/presentation/screens/detail_customer.dart';
import 'package:venus/src/features/customer/presentation/screens/edit_customer.dart';
import 'package:venus/src/features/customer/presentation/screens/list_customer.dart';
import 'package:venus/src/features/employee/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/employee/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/employee/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/employee/presentation/screens/create_employee.dart';
import 'package:venus/src/features/employee/presentation/screens/detail_employee.dart';
import 'package:venus/src/features/employee/presentation/screens/edit_employee.dart';
import 'package:venus/src/features/employee/presentation/screens/list_employee.dart';
import 'package:venus/src/features/order/presentation/blocs/approve_designer/approve_designer_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/assign_desginer/assign_designer_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/designer_action/designer_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/detail/detail_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/edit/edit_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/print_action/print_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/reviewer_action/reviewer_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/ship_action/ship_action_cubit.dart';
import 'package:venus/src/features/order/presentation/blocs/wearing_action/wearing_action_cubit.dart';
import 'package:venus/src/features/order/presentation/screens/create_order.dart';
import 'package:venus/src/features/order/presentation/screens/detail_order.dart';
import 'package:venus/src/features/order/presentation/screens/edit_order.dart';
import 'package:venus/src/features/order/presentation/screens/list_order.dart';
import 'package:venus/src/utils/device/device.dart';

class AppRoutes {
  static final GoRouter routes = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: "/",
          builder: (context, state) => const HomeScreen(),
          redirect: (context, state) {
            final role = context.read<AppBloc>().state.role;
            final isAuthenticated = context.read<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated) {
              if (!TDeviceUtils.isWeb()) {
                return "/home";
              }
              return "/sign-in";
            }

            if (role == Role.admin) {
              return "/branch";
            }
            if (role == Role.branchAdmin) {
              return "/doctor";
            }
            if (role == Role.designer ||
                role == Role.printer ||
                role == Role.reviewer ||
                role == Role.shipper ||
                role == Role.leadDesigner) {
              return "/order";
            }
            if (role == Role.branchDoctor) {
              return "/customer";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/sign-in",
          builder: (context, state) => const SignInScreen(),
          redirect: (context, state) {
            if (!TDeviceUtils.isWeb()) {
              final role = context.read<AppBloc>().state.role;
              final isAuthenticated = context.read<AppBloc>().state.status;
              if (isAuthenticated == AppStatus.unauthenticated) {
                return "/sign-in";
              }

              if (role == Role.admin) {
                return "/branch";
              }
              if (role == Role.branchAdmin) {
                return "/doctor";
              }
              if (role == Role.designer ||
                  role == Role.printer ||
                  role == Role.reviewer ||
                  role == Role.shipper ||
                  role == Role.leadDesigner) {
                return "/order";
              }
              if (role == Role.branchDoctor) {
                return "/customer";
              }
              return "/";
            } else {
              final role = context.watch<AppBloc>().state.role;
              final isAuthenticated = context.watch<AppBloc>().state.status;
              if (isAuthenticated == AppStatus.unauthenticated) {
                return "/sign-in";
              }

              if (role == Role.admin) {
                return "/branch";
              }
              if (role == Role.branchAdmin) {
                return "/doctor";
              }
              if (role == Role.designer ||
                  role == Role.printer ||
                  role == Role.reviewer ||
                  role == Role.shipper ||
                  role == Role.leadDesigner) {
                return "/order";
              }
              if (role == Role.branchDoctor) {
                return "/customer";
              }
              return "/";
            }
          },
        ),
        GoRoute(
          path: "/home",
          builder: (context, state) => const HomeScreenMobileUnAuthentiated(),
          redirect: (context, state) {
            final isAuthenticated = context.watch<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated) {
              if (!TDeviceUtils.isWeb()) {
                return "/home";
              }
              return "/sign-in";
            }
            return "/";
          },
        ),
        GoRoute(
          path: "/aligners",
          builder: (context, state) => const AlignerScreen(),
          redirect: (context, state) {
            final role = context.read<AppBloc>().state.role;
            final isAuthenticated = context.read<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated ||
                role != Role.customer) {
              return "/sign-in";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/wearings",
          builder: (context, state) {
            return BlocProvider<WearingCubit>(
              create: (_) => WearingCubit(),
              child: const WearingScreen(),
            );
          },
          redirect: (context, state) {
            final role = context.read<AppBloc>().state.role;
            final isAuthenticated = context.read<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated ||
                role != Role.customer) {
              return "/sign-in";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/appointments",
          builder: (context, state) {
            return BlocProvider<CreateAppointmentCubit>(
              create: (_) => CreateAppointmentCubit(),
              child: const AppointmentScreen(),
            );
          },
          redirect: (context, state) {
            final role = context.read<AppBloc>().state.role;
            final isAuthenticated = context.read<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated ||
                role != Role.customer) {
              return "/sign-in";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/profile",
          builder: (context, state) {
            return BlocProvider<EditProfileCubit>(
              create: (_) => EditProfileCubit(),
              child: const ProfileScreen(),
            );
          },
          redirect: (context, state) {
            final role = context.read<AppBloc>().state.role;
            final isAuthenticated = context.read<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated ||
                role != Role.customer) {
              return "/sign-in";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/profile/edit",
          builder: (context, state) {
            return BlocProvider<EditProfileCubit>(
              create: (_) => EditProfileCubit(),
              child: const EditProfileScreen(),
            );
          },
          redirect: (context, state) {
            final role = context.read<AppBloc>().state.role;
            final isAuthenticated = context.read<AppBloc>().state.status;
            if (isAuthenticated == AppStatus.unauthenticated ||
                role != Role.customer) {
              return "/sign-in";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/forgot-password",
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Appointment
        GoRoute(
            path: "/appointment",
            builder: (context, state) {
              return BlocProvider<CreateAppointmentCubit>(
                create: (_) => CreateAppointmentCubit(),
                child: const CreateAppointmentScreen(uid: ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/appointment/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<CreateAppointmentCubit>(
                create: (_) => CreateAppointmentCubit(),
                child: CreateAppointmentScreen(uid: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),

        // BRANCH ROUTER
        GoRoute(
            path: "/branch",
            builder: (context, state) => const ListBranchScreen(),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-branch",
            builder: (context, state) {
              return BlocProvider<CreateBranchCubit>(
                create: (_) => CreateBranchCubit(),
                child: const CreateBranchScreen(),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/branch/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailBranchCubit>(
                create: (_) => DetailBranchCubit(),
                child: DetailBranchScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/branch/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditBranchCubit>(
                create: (_) => EditBranchCubit(),
                child: EditBranchScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),

        // Employee
        GoRoute(
            path: "/lead-designer",
            builder: (context, state) =>
                const ListEmployeeScreen(role: "lead-designer"),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/lead-designer",
            builder: (context, state) =>
                const ListEmployeeScreen(role: "lead-designer"),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/designer",
            builder: (context, state) =>
                const ListEmployeeScreen(role: "designer"),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/reviewer",
            builder: (context, state) =>
                const ListEmployeeScreen(role: "reviewer"),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/shipper",
            builder: (context, state) =>
                const ListEmployeeScreen(role: "shipper"),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/printer",
            builder: (context, state) =>
                const ListEmployeeScreen(role: "printer"),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-lead-designer",
            builder: (context, state) {
              return BlocProvider<CreateEmployeeCubit>(
                create: (_) => CreateEmployeeCubit(),
                child: const CreateEmployeeScreen(role: "lead-designer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-designer",
            builder: (context, state) {
              return BlocProvider<CreateEmployeeCubit>(
                create: (_) => CreateEmployeeCubit(),
                child: const CreateEmployeeScreen(role: "designer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-reviewer",
            builder: (context, state) {
              return BlocProvider<CreateEmployeeCubit>(
                create: (_) => CreateEmployeeCubit(),
                child: const CreateEmployeeScreen(role: "reviewer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-shipper",
            builder: (context, state) {
              return BlocProvider<CreateEmployeeCubit>(
                create: (_) => CreateEmployeeCubit(),
                child: const CreateEmployeeScreen(role: "shipper"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-printer",
            builder: (context, state) {
              return BlocProvider<CreateEmployeeCubit>(
                create: (_) => CreateEmployeeCubit(),
                child: const CreateEmployeeScreen(role: "printer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),

        GoRoute(
            path: "/lead-designer/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailEmployeeCubit>(
                create: (_) => DetailEmployeeCubit(),
                child:
                    DetailEmployeeScreen(id: id ?? "", role: "lead-designer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/designer/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailEmployeeCubit>(
                create: (_) => DetailEmployeeCubit(),
                child: DetailEmployeeScreen(id: id ?? "", role: "designer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/reviewer/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailEmployeeCubit>(
                create: (_) => DetailEmployeeCubit(),
                child: DetailEmployeeScreen(id: id ?? "", role: "reviewer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/shipper/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailEmployeeCubit>(
                create: (_) => DetailEmployeeCubit(),
                child: DetailEmployeeScreen(id: id ?? "", role: "shipper"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/printer/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailEmployeeCubit>(
                create: (_) => DetailEmployeeCubit(),
                child: DetailEmployeeScreen(id: id ?? "", role: "printer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/lead-designer/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditEmployeeCubit>(
                create: (_) => EditEmployeeCubit(),
                child: EditEmployeeScreen(id: id ?? "", role: "lead-designer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/designer/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditEmployeeCubit>(
                create: (_) => EditEmployeeCubit(),
                child: EditEmployeeScreen(id: id ?? "", role: "designer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/reviewer/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditEmployeeCubit>(
                create: (_) => EditEmployeeCubit(),
                child: EditEmployeeScreen(id: id ?? "", role: "reviewer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/printer/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditEmployeeCubit>(
                create: (_) => EditEmployeeCubit(),
                child: EditEmployeeScreen(id: id ?? "", role: "printer"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/shipper/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditEmployeeCubit>(
                create: (_) => EditEmployeeCubit(),
                child: EditEmployeeScreen(id: id ?? "", role: "shipper"),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),

        // Doctor
        GoRoute(
            path: "/doctor",
            builder: (context, state) => const ListDoctorScreen(),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin && role != Role.branchAdmin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-doctor",
            builder: (context, state) {
              return BlocProvider<CreateBranchEmployeeCubit>(
                create: (_) => CreateBranchEmployeeCubit(),
                child: const CreateDoctorScreen(id: ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin && role != Role.branchAdmin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-doctor/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<CreateBranchEmployeeCubit>(
                create: (_) => CreateBranchEmployeeCubit(),
                child: CreateDoctorScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin && role != Role.branchAdmin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/doctor/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailBranchEmployeeCubit>(
                create: (_) => DetailBranchEmployeeCubit(),
                child: DetailDoctorScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin && role != Role.branchAdmin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/doctor/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditBranchEmployeeCubit>(
                create: (_) => EditBranchEmployeeCubit(),
                child: EditDoctorScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin && role != Role.branchAdmin) {
                return "/";
              }
              return null;
            }),

        // Admin
        GoRoute(
            path: "/admin",
            builder: (context, state) => const ListAdminScreen(),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-admin",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<CreateBranchEmployeeCubit>(
                create: (_) => CreateBranchEmployeeCubit(),
                child: CreateAdminScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-admin/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<CreateBranchEmployeeCubit>(
                create: (_) => CreateBranchEmployeeCubit(),
                child: CreateAdminScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/admin/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailBranchEmployeeCubit>(
                create: (_) => DetailBranchEmployeeCubit(),
                child: DetailAdminScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/admin/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditBranchEmployeeCubit>(
                create: (_) => EditBranchEmployeeCubit(),
                child: EditAdminScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin) {
                return "/";
              }
              return null;
            }),

        // Customer
        GoRoute(
            path: "/customer",
            builder: (context, state) => const ListCustomerScreen(),
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin &&
                  role != Role.branchAdmin &&
                  role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/create-customer",
            builder: (context, state) {
              return BlocProvider<CreateCustomerCubit>(
                create: (_) => CreateCustomerCubit(),
                child: const CreateCustomerScreen(),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin &&
                  role != Role.branchAdmin &&
                  role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/customer/edit/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<EditCustomerCubit>(
                create: (_) => EditCustomerCubit(),
                child: EditCustomerScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin &&
                  role != Role.branchAdmin &&
                  role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/customer/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<DetailCustomerCubit>(
                create: (_) => DetailCustomerCubit(),
                child: DetailCustomerScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin &&
                  role != Role.branchAdmin &&
                  role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),
        GoRoute(
            path: "/customer/create-order/:id",
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return BlocProvider<CreateOrderCubit>(
                create: (_) => CreateOrderCubit(),
                child: CreateOrderScreen(id: id ?? ""),
              );
            },
            redirect: (context, state) {
              final role = context.read<AppBloc>().state.role;
              if (role != Role.admin &&
                  role != Role.branchAdmin &&
                  role != Role.branchDoctor) {
                return "/";
              }
              return null;
            }),

        // Order
        GoRoute(
          path: "/order",
          builder: (context, state) => const ListOrderScreen(),
        ),
        GoRoute(
          path: "/order/:id",
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return BlocProvider<DetailOrderCubit>(
              create: (_) => DetailOrderCubit(),
              child: DetailOrderScreen(id: id ?? ""),
            );
          },
        ),
        GoRoute(
          path: "/create-order",
          builder: (context, state) {
            return BlocProvider<CreateOrderCubit>(
              create: (_) => CreateOrderCubit(),
              child: const CreateOrderScreen(id: ""),
            );
          },
        ),
        GoRoute(
          path: "/order/edit/:id",
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => EditOrderCubit()),
                BlocProvider(create: (_) => AssignDesignerCubit()),
                BlocProvider(create: (_) => DesignerActionCubit()),
                BlocProvider(create: (_) => ReviewerActionCubit()),
                BlocProvider(create: (_) => ApproveActionCubit()),
                BlocProvider(create: (_) => PrintActionCubit()),
                BlocProvider(create: (_) => ShipActionCubit()),
                BlocProvider(create: (_) => WearingActionCubit()),
              ],
              child: EditOrderScreen(id: id ?? ""),
            );
          },
        ),
      ]);
}
