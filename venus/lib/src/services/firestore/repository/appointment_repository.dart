import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/appointment.dart';

class AppointmentRepository {
  AppointmentRepository({
    CollectionReference? appointmentCollections,
  }) : _appointmentCollections = appointmentCollections ??
            FirebaseFirestore.instance.collection('appointment');
  final CollectionReference _appointmentCollections;

  Future<List<MyAppointment>> listAppointment() async {
    QuerySnapshot querySnapshot = await _appointmentCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return response.map((data) {
      return MyAppointment(
        id: data['id'],
        customerId: data['customerId'],
        doctorId: data['doctorId'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        subject: data['subject'],
        location: data['location'],
        color: data['color'],
        notes: data['notes'],
      );
    }).toList();
  }

  Future<MyAppointment> getAppointment(String id) async {
    final snap = await _appointmentCollections.doc(id).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return MyAppointment(
        id: data['id'],
        customerId: data['customerId'],
        doctorId: data['doctorId'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        subject: data['subject'],
        location: data['location'],
        color: data['color'],
        notes: data['notes'],
      );
    }
    return MyAppointment.empty;
  }

  Future<void> createAppointment(MyAppointment appointment) async {
    try {
      await _appointmentCollections.doc(appointment.id).set({
        "id": appointment.id,
        "customerId": appointment.customerId,
        "doctorId": appointment.doctorId,
        "startTime": appointment.startTime,
        "endTime": appointment.endTime,
        "subject": appointment.subject,
        "notes": appointment.notes,
        "location": appointment.location,
        "color": appointment.color,
      });
    } catch (_) {}
  }

  Future<void> updateAppointment(MyAppointment appointment) async {
    try {
      await _appointmentCollections.doc(appointment.id).update({
        "id": appointment.id,
        "customerId": appointment.customerId,
        "doctorId": appointment.doctorId,
        "startTime": appointment.startTime,
        "endTime": appointment.endTime,
        "subject": appointment.subject,
        "notes": appointment.notes,
        "location": appointment.location,
        "color": appointment.color,
      });
    } catch (_) {}
  }

  Future<void> deleteAppointment(MyAppointment appointment) async {
    try {
      await _appointmentCollections.doc(appointment.id).delete();
    } catch (_) {}
  }
}
