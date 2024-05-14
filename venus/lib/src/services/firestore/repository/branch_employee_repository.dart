import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/services/firestore/entities/branch_employee.dart';

class BranchEmployeeRepository {
  BranchEmployeeRepository({
    CollectionReference? branchEmployeeCollections,
  }) : _branchEmployeeCollections = branchEmployeeCollections ??
            FirebaseFirestore.instance.collection('branch_employee');
  final CollectionReference _branchEmployeeCollections;

  Future<List<BranchEmployee>> listBranchEmployeesWithUser(
      {required Role role, required String uid}) async {
    QuerySnapshot querySnapshot = await _branchEmployeeCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    final employees = response.map((data) {
      return BranchEmployee(
        uid: data['uid'],
        branchId: data['branchId'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        role: data['role'],
      );
    }).toList();

    if (role == Role.branchAdmin) {
      final branchAdmin = await getBranchEmployee(uid);
      return employees
          .where((element) => element.branchId == branchAdmin.branchId)
          .toList();
    }

    return employees;
  }

  Future<List<BranchEmployee>> listBranchEmployees() async {
    QuerySnapshot querySnapshot = await _branchEmployeeCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    final employees = response.map((data) {
      return BranchEmployee(
        uid: data['uid'],
        branchId: data['branchId'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        role: data['role'],
      );
    }).toList();
    return employees;
  }

  Future<BranchEmployee> getBranchEmployee(String uid) async {
    final snap = await _branchEmployeeCollections.doc(uid).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return BranchEmployee(
        uid: uid,
        branchId: data['branchId'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        role: data['role'],
      );
    }
    return BranchEmployee.empty;
  }

  Future<void> createBranchEmployee(BranchEmployee branchEmployee) async {
    try {
      await _branchEmployeeCollections.doc(branchEmployee.uid).set({
        "uid": branchEmployee.uid,
        "branchId": branchEmployee.branchId,
        "name": branchEmployee.name,
        "email": branchEmployee.email,
        "phone": branchEmployee.phone,
        "address": branchEmployee.address,
        "description": branchEmployee.description,
        "role": branchEmployee.role,
      });
    } catch (_) {}
  }

  Future<void> updateBranchEmployee(BranchEmployee branchEmployee) async {
    try {
      await _branchEmployeeCollections.doc(branchEmployee.uid).update({
        "uid": branchEmployee.uid,
        "branchId": branchEmployee.branchId,
        "name": branchEmployee.name,
        "email": branchEmployee.email,
        "phone": branchEmployee.phone,
        "address": branchEmployee.address,
        "description": branchEmployee.description,
        "role": branchEmployee.role,
      });
    } catch (_) {}
  }

  Future<void> deleteBranchEmployee(BranchEmployee branchEmployee) async {
    try {
      await _branchEmployeeCollections.doc(branchEmployee.uid).delete();
    } catch (_) {}
  }
}
