import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CreateAppointmentStatus { initial, submitting, success, error }

final class CreateAppointmentState extends Equatable {
  final String customerId;
  final DateTime dateStart;
  final TimeOfDay timeStart;
  final DateTime dateEnd;
  final TimeOfDay timeEnd;
  final String subject;
  final String location;
  final String notes;
  final CreateAppointmentStatus status;

  factory CreateAppointmentState.initial() {
    return CreateAppointmentState(
      customerId: '',
      dateStart: DateTime.now(),
      dateEnd: DateTime.now(),
      location: '',
      notes: '',
      subject: '',
      timeEnd: TimeOfDay.now(),
      timeStart: TimeOfDay.now(),
      status: CreateAppointmentStatus.initial,
    );
  }

  CreateAppointmentState copyWith({
    String? customerId,
    DateTime? dateStart,
    TimeOfDay? timeStart,
    DateTime? dateEnd,
    TimeOfDay? timeEnd,
    String? subject,
    String? location,
    String? notes,
    CreateAppointmentStatus? status,
  }) {
    return CreateAppointmentState(
      customerId: customerId ?? this.customerId,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      subject: subject ?? this.subject,
      timeEnd: timeEnd ?? this.timeEnd,
      timeStart: timeStart ?? this.timeStart,
      status: status ?? this.status,
    );
  }

  const CreateAppointmentState({
    required this.customerId,
    required this.dateStart,
    required this.dateEnd,
    required this.timeStart,
    required this.timeEnd,
    required this.subject,
    required this.location,
    required this.notes,
    required this.status,
  });

  @override
  List<Object> get props => [
        customerId,
        dateStart,
        dateEnd,
        timeStart,
        timeEnd,
        subject,
        location,
        notes,
        status,
      ];
}
