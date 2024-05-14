import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/app/bloc/app_state.dart';
import 'package:venus/src/services/firestore/entities/order.dart';
import 'package:venus/src/services/firestore/repository/branch_employee_repository.dart';
import 'package:venus/src/services/firestore/repository/customer_repository.dart';

class AlignerOrderRepository {
  AlignerOrderRepository({
    CollectionReference? alignerOrderCollections,
  }) : _alignerOrderCollections = alignerOrderCollections ??
            FirebaseFirestore.instance.collection('order');
  final CollectionReference _alignerOrderCollections;

  Future<List<AlignerOrder>> listAlignerOrders(
      {required Role role, required String uid}) async {
    QuerySnapshot querySnapshot = await _alignerOrderCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    print(response);

    final orders = response.map((data) {
      return AlignerOrder(
        id: data['id'],
        customerId: data['customerId'],
        designerId: data['designerId'],
        printerId: data['printerId'],
        reviewerId: data['reviewerId'],
        shipperId: data['shipperId'],
        createAt: data['createAt'],
        description: data['description'],
        imagesScan: data['imagesScan'],
        fileDesign: data['fileDesign'],
        linkDesign: data['linkDesign'],
        addressReceive: data['addressReceive'],
        caseInWeek: data['caseInWeek'],
        casePrinted: data['casePrinted'],
        passCode: data['passCode'],
        totalCase: data['totalCase'],
        userReceive: data['userReceive'],
        userSend: data['userSend'],
        printFrequency: data['printFrequency'],
        timeStart: data['timeStart'],
        tracking: data['tracking'],
        images: List.from(data["images"] ?? []),
        status: data['status'],
      );
    }).toList();

    if (role == Role.branchAdmin) {
      final response = await CustomerRepository().listCustomers();
      final admin = await BranchEmployeeRepository().getBranchEmployee(uid);
      final customers = response.where((element) => element.branchId == admin.branchId).toList();

      return orders.where((element) {
        var flag = false;
        for (var i = 0; i < customers.length; i++) {
          if (customers[i].uid == element.customerId) {
            flag = true;
            break;
          }
        }
        return flag;
      }).toList();
    }

    if (role == Role.branchDoctor) {
      final response = await CustomerRepository().listCustomers();
      final customers = response.where((element) => element.doctorId == uid).toList();

      return orders.where((element) {
        var flag = false;
        for (var i = 0; i < customers.length; i++) {
          if (customers[i].uid == element.customerId) {
            flag = true;
            break;
          }
        }
        return flag;
      }).toList();
    }
    return orders;
  }

  Future<AlignerOrder> getAlignerOrder(String id) async {
    final snap = await _alignerOrderCollections.doc(id).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return AlignerOrder(
        id: id,
        customerId: data['customerId'],
        designerId: data['designerId'],
        printerId: data['printerId'],
        reviewerId: data['reviewerId'],
        shipperId: data['shipperId'],
        createAt: data['createAt'],
        description: data['description'],
        imagesScan: data['imagesScan'],
        fileDesign: data['fileDesign'],
        linkDesign: data['linkDesign'],
        addressReceive: data['addressReceive'],
        caseInWeek: data['caseInWeek'],
        casePrinted: data['casePrinted'],
        passCode: data['passCode'],
        totalCase: data['totalCase'],
        userReceive: data['userReceive'],
        userSend: data['userSend'],
        printFrequency: data['printFrequency'],
        tracking: data['tracking'],
        timeStart: data['timeStart'],
        images: List.from(data["images"] ?? []),
        status: data['status'],
      );
    }
    return AlignerOrder.empty;
  }

  Future<void> createAlignerOrder(AlignerOrder alignerOrder) async {
    try {
      await _alignerOrderCollections.doc(alignerOrder.id).set({
        "id": alignerOrder.id,
        "customerId": alignerOrder.customerId,
        "designerId": alignerOrder.designerId,
        "printerId": alignerOrder.printerId,
        "shipperId": alignerOrder.shipperId,
        "reviewerId": alignerOrder.reviewerId,
        "createAt": alignerOrder.createAt,
        "description": alignerOrder.description,
        "imagesScan": alignerOrder.imagesScan,
        "fileDesign": alignerOrder.fileDesign,
        "linkDesign": alignerOrder.linkDesign,
        "printFrequency": alignerOrder.printFrequency,
        "addressReceive": alignerOrder.addressReceive,
        "caseInWeek": alignerOrder.caseInWeek,
        "casePrinted": alignerOrder.casePrinted,
        "userReceive": alignerOrder.userReceive,
        "userSend": alignerOrder.userSend,
        "passCode": alignerOrder.passCode,
        "totalCase": alignerOrder.totalCase,
        "timeStart": alignerOrder.timeStart,
        "tracking": alignerOrder.tracking,
        "images": FieldValue.arrayUnion(alignerOrder.images as List<dynamic>),
        "status": alignerOrder.status,
      });
    } catch (_) {}
  }

  Future<void> updateAlignerOrder(AlignerOrder alignerOrder) async {
    try {
      await _alignerOrderCollections.doc(alignerOrder.id).update({
        "id": alignerOrder.id,
        "customerId": alignerOrder.customerId,
        "designerId": alignerOrder.designerId,
        "printerId": alignerOrder.printerId,
        "shipperId": alignerOrder.shipperId,
        "reviewerId": alignerOrder.reviewerId,
        "createAt": alignerOrder.createAt,
        "description": alignerOrder.description,
        "imagesScan": alignerOrder.imagesScan,
        "fileDesign": alignerOrder.fileDesign,
        "linkDesign": alignerOrder.linkDesign,
        "printFrequency": alignerOrder.printFrequency,
        "addressReceive": alignerOrder.addressReceive,
        "caseInWeek": alignerOrder.caseInWeek,
        "casePrinted": alignerOrder.casePrinted,
        "userReceive": alignerOrder.userReceive,
        "userSend": alignerOrder.userSend,
        "passCode": alignerOrder.passCode,
        "totalCase": alignerOrder.totalCase,
        "tracking": alignerOrder.tracking,
        "timeStart": alignerOrder.timeStart,
        "images": FieldValue.arrayRemove(alignerOrder.images as List<dynamic>),
        "status": alignerOrder.status,
      });

      await _alignerOrderCollections.doc(alignerOrder.id).update({
        "id": alignerOrder.id,
        "customerId": alignerOrder.customerId,
        "designerId": alignerOrder.designerId,
        "printerId": alignerOrder.printerId,
        "shipperId": alignerOrder.shipperId,
        "reviewerId": alignerOrder.reviewerId,
        "createAt": alignerOrder.createAt,
        "description": alignerOrder.description,
        "imagesScan": alignerOrder.imagesScan,
        "fileDesign": alignerOrder.fileDesign,
        "linkDesign": alignerOrder.linkDesign,
        "printFrequency": alignerOrder.printFrequency,
        "addressReceive": alignerOrder.addressReceive,
        "caseInWeek": alignerOrder.caseInWeek,
        "casePrinted": alignerOrder.casePrinted,
        "userReceive": alignerOrder.userReceive,
        "userSend": alignerOrder.userSend,
        "passCode": alignerOrder.passCode,
        "totalCase": alignerOrder.totalCase,
        "tracking": alignerOrder.tracking,
        "timeStart": alignerOrder.timeStart,
        "images": FieldValue.arrayUnion(alignerOrder.images as List<dynamic>),
        "status": alignerOrder.status,
      });

    } catch (_) {}
  }

  Future<void> deleteAligerOrder(AlignerOrder alignerOrder) async {
    try {
      await _alignerOrderCollections.doc(alignerOrder.id).delete();
    } catch (_) {}
  }
}
