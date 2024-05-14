import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/appointment/presentation/blocs/create/create_state.dart';
import 'package:venus/src/services/firestore/entities/appointment.dart';
import 'package:venus/src/services/firestore/repository/appointment_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class CreateAppointmentCubit extends Cubit<CreateAppointmentState> {
  CreateAppointmentCubit() : super(CreateAppointmentState.initial());

  bool isAllowCreate({required String customerId}) {
    final timeStart = DateTime(state.dateStart.year, state.dateStart.month,
        state.dateStart.day, state.timeStart.hour, state.timeStart.minute);
    if (customerId == "") {
      if (state.subject == '' ||
          state.location == '' || state.customerId == "" ||
          timeStart.difference(DateTime.now()).inMicroseconds < 0) {
        return false;
      }
      return true;
    }
    if (state.subject == '' ||
        state.location == '' ||
        timeStart.difference(DateTime.now()).inMicroseconds < 0) {
      return false;
    }
    return true;
  }

  void onSubmit() {
    emit(state.copyWith(status: CreateAppointmentStatus.submitting));
  }

  void onSuccess() {
    emit(state.copyWith(status: CreateAppointmentStatus.success));
  }

  void locationChanged(String value) {
    emit(state.copyWith(
        location: value, status: CreateAppointmentStatus.initial));
  }

  void subjectChanged(String value) {
    emit(state.copyWith(
        subject: value, status: CreateAppointmentStatus.initial));
  }

  void notesChanged(String value) {
    emit(state.copyWith(notes: value, status: CreateAppointmentStatus.initial));
  }

  void customerIdChanged(String value) {
    emit(state.copyWith(
        customerId: value, status: CreateAppointmentStatus.initial));
  }

  void dateStartChanged(DateTime value) {
    emit(state.copyWith(
        dateStart: value,
        dateEnd: value.add(const Duration(hours: 1)),
        status: CreateAppointmentStatus.initial));
  }

  void dateEndChanged(DateTime value) {
    emit(state.copyWith(
        dateEnd: value, status: CreateAppointmentStatus.initial));
  }

  void timeStartChanged(TimeOfDay value) {
    emit(state.copyWith(
        timeStart: value,
        timeEnd: TimeOfDay(hour: value.hour + 1, minute: value.minute),
        status: CreateAppointmentStatus.initial));
  }

  void timeEndChanged(TimeOfDay value) {
    emit(state.copyWith(
        timeEnd: value, status: CreateAppointmentStatus.initial));
  }

  Future<void> createAppointmentSubmitting(
      {required String doctorId, required String customerId}) async {
    if (state.status == CreateAppointmentStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateAppointmentStatus.submitting));

    try {
      DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');

      final timeStart = DateTime(state.dateStart.year, state.dateStart.month,
          state.dateStart.day, state.timeStart.hour, state.timeStart.minute);

      final timeEnd = DateTime(state.dateEnd.year, state.dateEnd.month,
          state.dateEnd.day, state.timeEnd.hour, state.timeEnd.minute);

      final appointment = MyAppointment(
        id: generateID(),
        color: '',
        customerId: customerId == "" ? state.customerId : customerId,
        doctorId: doctorId,
        location: state.location,
        notes: state.notes,
        subject: state.subject,
        startTime: dateFormat.format(timeStart),
        endTime: dateFormat.format(timeEnd),
      );

      await AppointmentRepository().createAppointment(appointment);

      emit(state.copyWith(status: CreateAppointmentStatus.success));
    } catch (_) {}
  }

  Future<void> deleteAppointmentSubmitting({required String id}) async {
    if (state.status == CreateAppointmentStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: CreateAppointmentStatus.submitting));

    try {
      await AppointmentRepository().deleteAppointment(MyAppointment(
        id: id,
      ));

      emit(state.copyWith(status: CreateAppointmentStatus.success));
    } catch (_) {}
  }
}
