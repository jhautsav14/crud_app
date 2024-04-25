/*

this db stores the posts that users have published in the app.
It is stored in a collection called 'Post' in Firebase

Each post contains;
- a message
- email of user
- timestamp

*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase{

  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get the collection of post from firbase

  final CollectionReference posts = FirebaseFirestore.instance.collection('Posts');

  // post message
  Future<void> addPost(String message){
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage':message,
      'TimeStamp': Timestamp.now(),
    });
  }

  // read posts from db

  Stream<QuerySnapshot> getPostStream(){
    final postStream = FirebaseFirestore.instance.collection('Posts').orderBy('TimeStamp',descending: true).snapshots();
    return postStream;
  }

}