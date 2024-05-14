// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/common/components/icon_button.dart';
import 'package:venus/src/common/icons/progress.dart';
import 'package:venus/src/features/appointment/presentation/blocs/create/create_cubit.dart';
import 'package:venus/src/features/appointment/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firestore/entities/appointment.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/appointment_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';
import 'package:venus/src/utils/constants/colors.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget(
      {super.key,
      required this.customerId,
      required this.doctorId,
      required this.role});

  final String customerId;
  final String doctorId;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
        buildWhen: (previous, current) =>
            previous.status == CreateAppointmentStatus.submitting &&
            current.status == CreateAppointmentStatus.success,
        builder: (context, state) {
          return SizedBox(
            height: 586,
            child: Column(
              children: [
                FutureBuilder(
                  future: AppointmentRepository().listAppointment(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final appointments = snapshot.data!.where((element) {
                        if (role == Role.customer &&
                            element.customerId == customerId) {
                          return true;
                        }

                        if (customerId == "" && element.doctorId == doctorId) {
                          return true;
                        }
                        if (customerId != "" &&
                            element.customerId == customerId &&
                            element.doctorId == doctorId) {
                          return true;
                        }
                        return false;
                      }).toList();

                      return CalendarAppointmentWidget(
                          role: role,
                          data: appointments,
                          customerId: customerId,
                          doctorId: doctorId,
                          appointments:
                              getAppointments(appointments: appointments));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ],
            ),
          );
        });
  }
}

class CalendarAppointmentWidget extends StatefulWidget {
  const CalendarAppointmentWidget({
    super.key,
    required this.appointments,
    required this.customerId,
    required this.doctorId,
    required this.data,
    required this.role,
  });

  final List<Appointment> appointments;
  final String doctorId;
  final String customerId;
  final List<MyAppointment> data;
  final Role role;

  @override
  State<CalendarAppointmentWidget> createState() =>
      _CalendarAppointmentWidget();
}

class _CalendarAppointmentWidget extends State<CalendarAppointmentWidget> {
  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.schedule,
    CalendarView.month,
    CalendarView.timelineMonth,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineWeek,
    CalendarView.workWeek,
  ];

  final CalendarController calendarController = CalendarController();
  final CalendarView _view = CalendarView.week;

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.resourceHeader) {
      return;
    }

    if (calendarTapDetails.appointments == null &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell &&
        widget.role == Role.branchDoctor) {
      if (calendarTapDetails.date!.difference(DateTime.now()).inMinutes < 0) {
        return;
      }

      final start = calendarTapDetails.date ?? DateTime.now();

      final dateStart = DateTime(start.year, start.month, start.day);
      final timeStart = TimeOfDay(hour: start.hour, minute: start.minute);

      context.read<CreateAppointmentCubit>().dateStartChanged(dateStart);
      context.read<CreateAppointmentCubit>().timeStartChanged(timeStart);

      final dateEnd = dateStart.add(const Duration(hours: 1));
      final timeEnd = TimeOfDay(hour: timeStart.hour + 1, minute: start.minute);

      context.read<CreateAppointmentCubit>().dateEndChanged(dateEnd);
      context.read<CreateAppointmentCubit>().timeEndChanged(timeEnd);

      showDialog<Widget>(
        context: context,
        builder: (_) => BlocProvider.value(
            value: context.read<CreateAppointmentCubit>(),
            child: CreateAppointment(
                calendarTapDetails: calendarTapDetails,
                customerId: widget.customerId,
                doctorId: widget.doctorId)),
      );
    }

    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      showDialog<Widget>(
          context: context,
          builder: (_) => BlocProvider.value(
                value: context.read<CreateAppointmentCubit>(),
                child: AppointmentDetail(
                  role: widget.role,
                  data: widget.data,
                  calendarTapDetails: calendarTapDetails,
                  customerId: widget.customerId,
                  doctorId: widget.doctorId,
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 586,
      child: SfCalendar(
        todayHighlightColor: Colors.red,
        controller: calendarController,
        showDatePickerButton: true,
        allowedViews: _allowedViews,
        initialDisplayDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        view: _view,
        onTap: _onCalendarTapped,
        dataSource: MeetingDataSource(widget.appointments),
      ),
    );
  }
}

List<Appointment> getAppointments({required List<MyAppointment> appointments}) {
  return appointments.map((e) {
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    final startTime = dateFormat.parse(e.startTime ?? "");
    final endTime = dateFormat.parse(e.endTime ?? "");

    return Appointment(
      id: e.id,
      startTime: startTime,
      endTime: endTime,
      subject: e.subject ?? "",
      notes: e.notes,
      location: e.location,
    );
  }).toList();
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class AppointmentDetail extends StatelessWidget {
  const AppointmentDetail(
      {super.key,
      required this.calendarTapDetails,
      required this.customerId,
      required this.doctorId,
      required this.data,
      required this.role});

  final CalendarTapDetails calendarTapDetails;
  final String doctorId;
  final String customerId;
  final List<MyAppointment> data;
  final Role role;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
    final appointments = calendarTapDetails.appointments?[0] as Appointment;

    final item = data.firstWhere((element) => element.id == appointments.id);

    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Center(
            child: Material(
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: SizedBox(
                  height: 286,
                  width: 412,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 16, 24),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              role == Role.branchDoctor
                                  ? AIIconButton(
                                      onPressed: () async {
                                        await context
                                            .read<CreateAppointmentCubit>()
                                            .deleteAppointmentSubmitting(
                                                id: appointments.id.toString());
                                        Navigator.pop(context);
                                      },
                                      icon: state.status ==
                                              CreateAppointmentStatus.submitting
                                          ? const Icon(Icons.loop)
                                          : const Icon(Icons.delete))
                                  : const SizedBox(width: 0),
                              AIIconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 40),
                              Expanded(
                                  flex: 12,
                                  child: Text(appointments.subject,
                                      style: const TextStyle(fontSize: 18)))
                            ],
                          ),
                          const SizedBox(height: 16),
                          role == Role.branchDoctor
                              ? FutureBuilder(
                                  future: CustomerRepository()
                                      .getCustomer(item.customerId ?? ""),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      final customer = snapshot.data!;
                                      return Row(
                                        children: [
                                          const SizedBox(width: 40),
                                          TextButton(
                                              onPressed: () {
                                                context.go(
                                                    "/customer/${customer.uid}");
                                              },
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      const CircleAvatar(
                                                        radius: 16,
                                                        child: Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                            size: 16),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(customer.name ?? "")
                                                    ],
                                                  ))),
                                        ],
                                      );
                                    }
                                    return const SizedBox(height: 48);
                                  },
                                )
                              : const SizedBox(height: 0),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.schedule, size: 16),
                              const SizedBox(width: 24),
                              Expanded(
                                  flex: 12,
                                  child: Text(
                                      '${dateFormat.format(appointments.startTime)} - ${dateFormat.format(appointments.endTime)}')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 16),
                              const SizedBox(width: 24),
                              Expanded(
                                  flex: 12,
                                  child: Text(appointments.location ?? ""))
                            ],
                          ),
                          appointments.notes == ""
                              ? const Row()
                              : const SizedBox(height: 16),
                          appointments.notes == ""
                              ? const Row()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 40),
                                    Expanded(
                                        flex: 12,
                                        child: Text(appointments.notes ?? ""))
                                  ],
                                ),
                        ],
                      ))),
                )),
          );
        });
  }
}

class CreateAppointment extends StatelessWidget {
  const CreateAppointment(
      {super.key,
      required this.calendarTapDetails,
      required this.customerId,
      required this.doctorId});

  final CalendarTapDetails calendarTapDetails;
  final String doctorId;
  final String customerId;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormater = DateFormat('dd/MM/yyyy');
    DateFormat timeFormater = DateFormat('HH:mm');

    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Center(
          child: Material(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: SizedBox(
              height: 486,
              width: 524,
              child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        customerId == ""
                            ? FutureBuilder(
                                future: CustomerRepository().listCustomers(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    final customers = snapshot.data!
                                        .where((element) =>
                                            element.doctorId == doctorId)
                                        .toList();
                                    return Row(
                                      children: [
                                        const SizedBox(width: 40),
                                        CustomerAssignDropdown(
                                            customers: customers)
                                      ],
                                    );
                                  }
                                  return const Row();
                                },
                              )
                            : const Row(),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 40),
                            Expanded(flex: 12, child: TitleInput())
                          ],
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<CreateAppointmentCubit,
                                CreateAppointmentState>(
                            buildWhen: (previous, current) =>
                                previous != current,
                            builder: (context, state) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.schedule, size: 16),
                                  const SizedBox(width: 24),
                                  Expanded(
                                      flex: 4,
                                      child: TextButton(
                                          style: const ButtonStyle(
                                              fixedSize:
                                                  MaterialStatePropertyAll(
                                                      Size(120, 40))),
                                          onPressed: () => showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    BlocProvider.value(
                                                        value: context.read<
                                                            CreateAppointmentCubit>(),
                                                        child: Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          shadowColor:
                                                              Colors.white,
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(24),
                                                            height: 428,
                                                            width: 486,
                                                            child: DatePicker(
                                                              initialTime: state
                                                                  .dateStart,
                                                              onChanged:
                                                                  (time) {
                                                                context
                                                                    .read<
                                                                        CreateAppointmentCubit>()
                                                                    .dateStartChanged(
                                                                        time);
                                                              },
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                          child: Text(
                                              dateFormater
                                                  .format(state.dateStart),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight:
                                                      FontWeight.w100)))),
                                  Expanded(
                                      flex: 4,
                                      child: TextButton(
                                          style: const ButtonStyle(
                                              fixedSize:
                                                  MaterialStatePropertyAll(
                                                      Size(120, 40))),
                                          onPressed: () async {
                                            final initTime = state.timeStart;

                                            final TimeOfDay? time =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: initTime,
                                              initialEntryMode:
                                                  TimePickerEntryMode.dial,
                                            );
                                            context
                                                .read<CreateAppointmentCubit>()
                                                .timeStartChanged(
                                                    time ?? initTime);
                                          },
                                          child: Text(
                                              timeFormater.format(DateTime(
                                                  0,
                                                  0,
                                                  0,
                                                  state.timeStart.hour,
                                                  state.timeStart.minute)),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight:
                                                      FontWeight.w100)))),
                                  const Text("_"),
                                  Expanded(
                                      flex: 4,
                                      child: TextButton(
                                          style: const ButtonStyle(
                                              fixedSize:
                                                  MaterialStatePropertyAll(
                                                      Size(120, 40))),
                                          onPressed: () async {
                                            final initTime = state.timeEnd;

                                            final TimeOfDay? time =
                                                await showTimePicker(
                                              barrierColor: Colors.white,
                                              context: context,
                                              initialTime: initTime,
                                              initialEntryMode:
                                                  TimePickerEntryMode.dial,
                                            );
                                            context
                                                .read<CreateAppointmentCubit>()
                                                .timeEndChanged(
                                                    time ?? initTime);
                                          },
                                          child: Text(
                                              timeFormater.format(DateTime(
                                                  0,
                                                  0,
                                                  0,
                                                  state.timeEnd.hour,
                                                  state.timeEnd.minute)),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight:
                                                      FontWeight.w100)))),
                                  Expanded(
                                      flex: 4,
                                      child: TextButton(
                                          style: const ButtonStyle(
                                              fixedSize:
                                                  MaterialStatePropertyAll(
                                                      Size(120, 40))),
                                          onPressed: () => showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    BlocProvider.value(
                                                        value: context.read<
                                                            CreateAppointmentCubit>(),
                                                        child: Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          shadowColor:
                                                              Colors.white,
                                                          surfaceTintColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(24),
                                                            height: 428,
                                                            width: 486,
                                                            child: DatePicker(
                                                              initialTime:
                                                                  state.dateEnd,
                                                              onChanged:
                                                                  (time) {
                                                                context
                                                                    .read<
                                                                        CreateAppointmentCubit>()
                                                                    .dateEndChanged(
                                                                        time);
                                                              },
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                          child: Text(
                                              dateFormater
                                                  .format(state.dateEnd),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight:
                                                      FontWeight.w100)))),
                                ],
                              );
                            }),
                        const SizedBox(height: 16),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 24),
                            Expanded(flex: 12, child: LocationInput())
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 40),
                            Expanded(flex: 12, child: DescriptionInput())
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                                style: const ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)))),
                                    fixedSize:
                                        MaterialStatePropertyAll(Size(86, 40))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Close",
                                    style: TextStyle(color: Colors.black))),
                            const SizedBox(width: 16),
                            CreateButton(
                              customerId: customerId,
                              doctorId: doctorId,
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton(
      {super.key, required this.customerId, required this.doctorId});

  final String customerId;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  backgroundColor: MaterialStatePropertyAll(context
                          .read<CreateAppointmentCubit>()
                          .isAllowCreate(customerId: customerId)
                      ? HexColor("#DB1A20")
                      : Colors.grey),
                  fixedSize: const MaterialStatePropertyAll(Size(86, 40))),
              onPressed: () async {
                if (context
                        .read<CreateAppointmentCubit>()
                        .isAllowCreate(customerId: customerId) ==
                    false) {
                  return;
                }
                await context
                    .read<CreateAppointmentCubit>()
                    .createAppointmentSubmitting(
                        doctorId: doctorId, customerId: customerId);
                Navigator.pop(context);
              },
              child: state.status == CreateAppointmentStatus.submitting
                  ? const ProgressIcon(color: Colors.white)
                  : const Text("Save", style: TextStyle(color: Colors.white)));
        });
  }
}

class CustomerAssignDropdown extends StatefulWidget {
  const CustomerAssignDropdown({super.key, required this.customers});

  final List<Customer> customers;

  @override
  State<CustomerAssignDropdown> createState() => _CustomerAssignDropdownState();
}

class _CustomerAssignDropdownState extends State<CustomerAssignDropdown> {
  String doctorName = "Select Customer";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Customer'),
            const SizedBox(height: 8),
            DropdownMenu<String>(
              initialSelection: "",
              hintText: "Select Customer",
              menuStyle: const MenuStyle(
                backgroundColor: MaterialStatePropertyAll(TColors.white),
                surfaceTintColor: MaterialStatePropertyAll(TColors.white),
              ),
              width: 186,
              onSelected: (String? value) {
                setState(() {
                  doctorName = value!;
                });
                context
                    .read<CreateAppointmentCubit>()
                    .customerIdChanged(value ?? "");
              },
              dropdownMenuEntries: widget.customers
                  .map<DropdownMenuEntry<String>>((Customer value) {
                return DropdownMenuEntry<String>(
                    value: value.uid, label: value.name ?? "");
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker(
      {super.key, required this.initialTime, required this.onChanged});

  final DateTime initialTime;
  final Function(DateTime) onChanged;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class TitleInput extends StatelessWidget {
  const TitleInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return TextField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black)),
            hintText: 'Add title and time',
            hintStyle: TextStyle(fontSize: 16),
          ),
          style: const TextStyle(
            fontSize: 16,
          ),
          onChanged: (value) {
            context.read<CreateAppointmentCubit>().subjectChanged(value);
          },
        );
      },
    );
  }
}

class LocationInput extends StatelessWidget {
  const LocationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
              hintText: 'Enter location',
              hintStyle: TextStyle(fontSize: 14),
            ),
            style: const TextStyle(
              fontSize: 14,
            ),
            onChanged: (value) {
              context.read<CreateAppointmentCubit>().locationChanged(value);
            },
          );
        });
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
              hintText: 'Enter description',
              hintStyle: TextStyle(fontSize: 14),
            ),
            style: const TextStyle(
              fontSize: 14,
            ),
            onChanged: (value) {
              context.read<CreateAppointmentCubit>().notesChanged(value);
            },
            maxLines: 4,
          );
        });
  }
}

class _DatePickerState extends State<DatePicker> {
  DateTime pickedTime = DateTime.now();

  @override
  @override
  void initState() {
    pickedTime = widget.initialTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentCubit, CreateAppointmentState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarDatePicker(
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              initialDate: pickedTime,
              onDateChanged: (date) {
                setState(() {
                  pickedTime = date;
                });
                widget.onChanged(date);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("CANCLE",
                        style: TextStyle(color: Colors.black54))),
                const SizedBox(width: 16),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK")),
              ],
            )
          ],
        );
      },
    );
  }
}
