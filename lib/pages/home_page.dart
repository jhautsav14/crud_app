import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/components/my_drawer.dart';
import 'package:crud_app/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // fireStore
  FirestoreService firestoreService = FirestoreService();
  // text controller
  final TextEditingController textController = TextEditingController();
  // open a dialog box to add a note
  void openNoteBox({String? docID}){
    showDialog(
      context: context, 
      builder: (context)=> AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        title: Text("ADD Notes"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          // button to save
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
            onPressed: (){
              // add new note
              if(docID == null){
                firestoreService.addNote(textController.text);

              } else{
                firestoreService.updateNote(docID, textController.text);

              }
              
              // clear the text controller
              textController.clear();
              // close the box
              Navigator.pop(context);
            }, 
            child: Text("Add"),
          )

        ],
      )
      );
  }


  // logout

  void logout(){
    FirebaseAuth.instance.signOut();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Notes"),
          actions: [
            IconButton(onPressed: logout, icon: Icon(Icons.logout))
          ],
          
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          shape: CircleBorder(),
          onPressed: (){
            openNoteBox();
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            // if we have data, get all the doc

            if(snapshot.hasData){
              List notesList = snapshot.data!.docs;

              // display  as a list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index){
                  // get each individual doc
                  DocumentSnapshot document = notesList[index];
                  String docId = document.id;


                  // get note for each doc
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String noteText = data['note'];


                  // display as a list tile
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(noteText, style: TextStyle(color: Colors.black),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey,),
                              onPressed: () {
                                openNoteBox(docID: docId);
                                
                              },
                             ),
                            IconButton(
                              onPressed: ()=>firestoreService.deleteNote(docId), 
                              icon: Icon(Icons.delete, color: Colors.red,)
                            )
                          ],
                        )
                      ),
                    ),
                  );
                }
                
              );
            }else{
              return Text("No notes");
            }
            
            
          },
        ),
      );
      
    
  }
}