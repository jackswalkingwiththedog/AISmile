import 'package:equatable/equatable.dart';

class MyAppointment extends Equatable {
  const MyAppointment({
    required this.id,
    this.doctorId,
    this.customerId,
    this.startTime,
    this.endTime,
    this.subject,
    this.notes,
    this.location,
    this.color,
  });

  final String id;
  final String? doctorId;
  final String? customerId;
  final String? startTime;
  final String? endTime;
  final String? subject;
  final String? notes;
  final String? location;
  final String? color;

  static const empty = MyAppointment(id: '');
  bool get isEmpty => this == MyAppointment.empty;
  bool get isNotEmpty => this != MyAppointment.empty;

  @override
  List<Object?> get props => [
        id,
        doctorId,
        customerId,
        startTime,
        endTime,
        subject,
        notes,
        location,
        color,
      ];
}
