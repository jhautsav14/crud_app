import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  // get collection notes

  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // Create : add a new doc
  Future<void> addNote(String note){
    return notes.add({
      'note':note,
      'timestamp': Timestamp.now(),
    });
  }

  // Read : get notes from db
  Stream<QuerySnapshot> getNotesStream(){
    final notesStream = notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // Update : update notes given a doc id
  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp':Timestamp.now(),
    });
  }

  //delete : delete notes given a doc id

  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}