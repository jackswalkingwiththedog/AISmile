import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venus/src/services/firestore/entities/note.dart';

class NoteRepository {
  NoteRepository({
    CollectionReference? noteCollections,
  }) : _noteCollections =
            noteCollections ?? FirebaseFirestore.instance.collection('note');
  final CollectionReference _noteCollections;

  Future<List<Note>> listNotes() async {
    QuerySnapshot querySnapshot = await _noteCollections.get();
    final response = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return response.map((data) {
      return Note(
        id: data['id'],
        createAt: data['createAt'],
        customerId: data['customerId'],
        doctorId: data['doctorId'],
        note: data['note'],
      );
    }).toList();
  }

  Future<Note> getNote(String uid) async {
    final snap = await _noteCollections.doc(uid).get();
    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;
      return Note(
        id: data['id'],
        createAt: data['createAt'],
        customerId: data['customerId'],
        doctorId: data['doctorId'],
        note: data['note'],
      );
    }
    return Note.empty;
  }

  Future<void> createNote(Note note) async {
    try {
      await _noteCollections.doc(note.id).set({
        "id": note.id,
        "createAt": note.createAt,
        "customerId": note.customerId,
        "doctorId": note.doctorId,
        "note": note.note,
      });
    } catch (_) {}
  }

  Future<void> updateNote(Note note) async {
    try {
      await _noteCollections.doc(note.id).update({
        "id": note.id,
        "createAt": note.createAt,
        "customerId": note.customerId,
        "doctorId": note.doctorId,
        "note": note.note,
      });
    } catch (_) {}
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _noteCollections.doc(note.id).delete();
    } catch (_) {}
  }
}
