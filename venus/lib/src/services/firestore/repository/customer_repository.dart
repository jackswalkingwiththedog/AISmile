import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/services/firestore/entities/customer.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';

class CustomerRepository {
  CustomerRepository({
    CollectionReference? customerCollections,
  }) : _customerCollections = customerCollections ??
            FirebaseFirestore.instance.collection('customer');
  final CollectionReference _customerCollections;

  Future<List<Customer>> listCustomers() async {
    QuerySnapshot querySnapshot = await _customerCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return response.map((data) {
      return Customer(
        uid: data['uid'],
        branchId: data['branchId'],
        doctorId: data['doctorId'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        gender: data['gender'],
        birthday: data['birthday'],
        avatar: data['avatar'],
        address: data['address'],
        description: data['description'],
        images: List.from(data["images"] ?? []),
      );
    }).toList();
  }

  Future<List<Customer>> listCustomersWithUser(
      {required Role role, required String uid}) async {
    QuerySnapshot querySnapshot = await _customerCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    final customers = response.map((data) {
      return Customer(
        uid: data['uid'],
        branchId: data['branchId'],
        doctorId: data['doctorId'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        gender: data['gender'],
        birthday: data['birthday'],
        avatar: data['avatar'],
        address: data['address'],
        description: data['description'],
        images: List.from(data["images"] ?? []),
      );
    }).toList();

    if (role == Role.branchAdmin) {
      final branchEmployee =
          await BranchEmployeeRepository().getBranchEmployee(uid);
      return customers
          .where((element) => element.branchId == branchEmployee.branchId)
          .toList();
    }

    if (role == Role.branchDoctor) {
      return customers.where((element) => element.doctorId == uid).toList();
    }

    return customers;
  }

  Future<Customer> getCustomer(String uid) async {
    final snap = await _customerCollections.doc(uid).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return Customer(
        uid: uid,
        branchId: data['branchId'],
        doctorId: data['doctorId'],
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        gender: data['gender'],
        birthday: data['birthday'],
        avatar: data['avatar'],
        address: data['address'],
        description: data['description'],
        images: List.from(data["images"] ?? []),
      );
    }
    return Customer.empty;
  }

  Future<void> createCustomer(Customer customer) async {
    try {
      await _customerCollections.doc(customer.uid).set({
        "uid": customer.uid,
        "branchId": customer.branchId,
        "doctorId": customer.doctorId,
        "name": customer.name,
        "email": customer.email,
        "phone": customer.phone,
        "gender": customer.gender,
        "birthday": customer.birthday,
        "address": customer.address,
        "avatar": customer.avatar,
        "description": customer.description,
        "images": FieldValue.arrayUnion(customer.images as List<dynamic>),
      });
    } catch (_) {}
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _customerCollections.doc(customer.uid).update({
        "uid": customer.uid,
        "branchId": customer.branchId,
        "doctorId": customer.doctorId,
        "name": customer.name,
        "email": customer.email,
        "phone": customer.phone,
        "gender": customer.gender,
        "birthday": customer.birthday,
        "address": customer.address,
        "avatar": customer.avatar,
        "description": customer.description,
        "images": FieldValue.arrayRemove(customer.images as List<dynamic>),
      });

      await _customerCollections.doc(customer.uid).update({
        "uid": customer.uid,
        "branchId": customer.branchId,
        "doctorId": customer.doctorId,
        "name": customer.name,
        "email": customer.email,
        "phone": customer.phone,
        "gender": customer.gender,
        "birthday": customer.birthday,
        "address": customer.address,
        "avatar": customer.avatar,
        "description": customer.description,
        "images": FieldValue.arrayUnion(customer.images as List<dynamic>),
      });
    } catch (_) {}
  }

  Future<void> deleteCustomer(Customer customer) async {
    try {
      await _customerCollections.doc(customer.uid).delete();
    } catch (_) {}
  }
}
