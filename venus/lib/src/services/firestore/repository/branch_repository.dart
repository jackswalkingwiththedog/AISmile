import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/branch.dart';

class BranchRepository {
  BranchRepository({
    CollectionReference? branchCollections,
  }) : _branchCollections =
            branchCollections ?? FirebaseFirestore.instance.collection('branch');
  final CollectionReference _branchCollections;

  Future<List<Branch>> listBranchs() async {
    QuerySnapshot querySnapshot = await _branchCollections.get();
    final response = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return response.map((data) {
      return Branch(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        logo: data['logo'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        createAt: data['createAt'],
      );
    }).toList();
  }

  Future<Branch> getBranch(String id) async {
    final snap = await _branchCollections.doc(id).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return Branch(
        id: id,
        name: data['name'],
        email: data['email'],
        logo: data['logo'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        createAt: data['createAt'],
      );
    }
    return Branch.empty;
  }

  Future<void> createBranch(Branch branch) async {
    try {
      await _branchCollections.doc(branch.id).set({
        "id": branch.id,
        "name": branch.name,
        "logo": branch.logo,
        "email": branch.email,
        "phone": branch.phone,
        "address": branch.address,
        "description": branch.description,
        "createAt": branch.createAt,
      });
    } catch (_) {}
  }

  Future<void> updateBranch(Branch branch) async {
    try {
      await _branchCollections.doc(branch.id).update({
        "id": branch.id,
        "name": branch.name,
        "email": branch.email,
        "logo": branch.logo,
        "phone": branch.phone,
        "address": branch.address,
        "description": branch.description,
        "createAt": branch.createAt,
      });
    } catch (_) {}
  }

  Future<void> deleteBranch(Branch branch) async {
    try {
      await _branchCollections.doc(branch.id).delete();
    } catch (_) {}
  }
}