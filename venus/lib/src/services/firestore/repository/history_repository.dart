import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/history.dart';

class HistoryRepository {
  HistoryRepository({
    CollectionReference? noteCollections,
  }) : _noteCollections =
            noteCollections ?? FirebaseFirestore.instance.collection('history');
  final CollectionReference _noteCollections;

  Future<List<History>> listHistorys() async {
    QuerySnapshot querySnapshot = await _noteCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return response.map((data) {
      return History(
        id: data["id"],
        orderId: data['orderId'],
        createAt: data['createAt'],
        uid: data['uid'],
        role: data['role'],
        message: data['message'],
        procedure: data['procedure'],
        name: data['name'] ?? "",
        status: data['status'] ?? "",
      );
    }).toList();
  }

  Future<History> getHistory(String id) async {
    final snap = await _noteCollections.doc(id).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return History(
        id: id,
        orderId: data['orderId'],
        uid: data['uid'],
        role: data['role'],
        createAt: data['createAt'],
        procedure: data['procedure'],
        message: data['message'],
        name: data['name'] ?? "",
        status: data['status'] ?? "",
      );
    }
    return History.empty;
  }

  Future<void> createHistory(History note) async {
    try {
      await _noteCollections.doc(note.id).set({
        "id": note.id,
        "orderId": note.orderId,
        "uid": note.uid,
        "role": note.role,
        "createAt": note.createAt,
        "procedure": note.procedure,
        "message": note.message,
        "status": note.status,
        "name": note.name,
      });
    } catch (_) {}
  }

  Future<void> updateHistory(History note) async {
    try {
      await _noteCollections.doc(note.uid).update({
        "id": note.id,
        "orderId": note.orderId,
        "uid": note.uid,
        "role": note.role,
        "message": note.message,
        "createAt": note.createAt,
        "procedure": note.procedure,
        "status": note.status,
        "name": note.name,
      });
    } catch (_) {}
  }

  Future<void> deleteHistory(History note) async {
    try {
      await _noteCollections.doc(note.uid).delete();
    } catch (_) {}
  }
}
