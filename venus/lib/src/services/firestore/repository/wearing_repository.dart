import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/wearing.dart';

class WearingRepository {
  WearingRepository({
    CollectionReference? wearingCollections,
  }) : _wearingCollections = wearingCollections ??
            FirebaseFirestore.instance.collection('wearing');
  final CollectionReference _wearingCollections;

  Future<List<Wearing>> listWearings() async {
    QuerySnapshot querySnapshot = await _wearingCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return response.map((data) {
      return Wearing(
          id: data['id'],
          customerId: data['customerId'],
          createTime: data["createTime"],
          images: List.from(data["images"]),
          note: data['note']);
    }).toList();
  }

  Future<Wearing> getWearing(String id) async {
    final snap = await _wearingCollections.doc(id).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return Wearing(
          id: data['id'],
          customerId: data['customerId'],
          createTime: data["createTime"],
          images: List.from(data["images"]),
          note: data['note']);
    }
    return Wearing.empty;
  }

  Future<void> createWearing(Wearing wearing) async {
    try {
      await _wearingCollections.doc(wearing.id).set({
        "id": wearing.id,
        "customerId": wearing.customerId,
        "createTime": wearing.createTime,
        "images": FieldValue.arrayUnion(wearing.images as List<dynamic>),
        "note": wearing.note,
      });
    } catch (err) {
      print("ERROR $err");
    }
  }

  Future<void> updateWearing(Wearing wearing) async {
    try {
      await _wearingCollections.doc(wearing.id).update({
        "id": wearing.id,
        "customerId": wearing.customerId,
        "createTime": wearing.createTime,
        "images": FieldValue.arrayRemove(wearing.images as List<dynamic>),
        "note": wearing.note,
      });
    } catch (_) {}
  }

  Future<void> deleteWearing(Wearing wearing) async {
    try {
      await _wearingCollections.doc(wearing.id).delete();
    } catch (_) {}
  }
}
