import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/employee.dart';

class EmployeeRepository {
  EmployeeRepository({
    CollectionReference? employeeCollections,
  }) : _employeeCollections = employeeCollections ??
            FirebaseFirestore.instance.collection('employee');
  final CollectionReference _employeeCollections;

  Future<List<Employee>> listEmployees() async {
    QuerySnapshot querySnapshot = await _employeeCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return response.map((data) {
      return Employee(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        role: data['role'],
      );
    }).toList();
  }

  Future<Employee> getEmployee(String uid) async {
    final snap = await _employeeCollections.doc(uid).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return Employee(
        uid: uid,
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        role: data['role'],
      );
    }
    return Employee.empty;
  }

  Future<void> createEmployee(Employee employee) async {
    try {
      await _employeeCollections.doc(employee.uid).set({
        "uid": employee.uid,
        "name": employee.name,
        "email": employee.email,
        "phone": employee.phone,
        "address": employee.address,
        "description": employee.description,
        "role": employee.role,
      });
    } catch (_) {}
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await _employeeCollections.doc(employee.uid).update({
        "uid": employee.uid,
        "name": employee.name,
        "email": employee.email,
        "phone": employee.phone,
        "address": employee.address,
        "description": employee.description,
        "role": employee.role,
      });
    } catch (_) {}
  }

  Future<void> deleteBranchEmployee(Employee employee) async {
    try {
      await _employeeCollections.doc(employee.uid).delete();
    } catch (_) {}
  }
}
