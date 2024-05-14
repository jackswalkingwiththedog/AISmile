import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/user.dart';

class UserRepository {
  UserRepository({
    CollectionReference? userCollections,
  }) : _userCollections =
            userCollections ?? FirebaseFirestore.instance.collection('user');
  final CollectionReference _userCollections;

  Future<List<User>> listUsers() async {
    QuerySnapshot querySnapshot = await _userCollections.get();
    final response = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return response.map((data) {
      return User(
        uid: data['uid'],
        role: data['role'],
      );
    }).toList();
  }

  Future<User> getUser(String uid) async {
    final snap = await _userCollections.doc(uid).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return User(
        uid: uid,
        role: data['role'],
      );
    }
    return User.empty;
  }

  Future<void> createUser(User user) async {
    try {
      await _userCollections.doc(user.uid).set({
        "uid": user.uid,
        "role": user.role,
      });
    } catch (_) {}
  }

  Future<void> updateUser(User user) async {
    try {
      await _userCollections.doc(user.uid).update({
        "uid": user.uid,
        "role": user.role,
      });
    } catch (_) {}
  }

  Future<void> deleteUser(User user) async {
    try {
      await _userCollections.doc(user.uid).delete();
    } catch (_) {}
  }
}
