import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          // any error
          if(snapshot.hasError){
            displayMessageToUser("Somthing went wrong", context);
          }

          // show loading circle
          if(snapshot.connectionState== ConnectionState.waiting){
           return  Center(
              child: CircularProgressIndicator(),
            );
          }

          // get all users

          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              // get individual user
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListTile(
                  
                  tileColor: Colors.white,
                  title: Text(user['username']),
                  subtitle: Text(user['email']),
                
                ),
              );

            },
          );
        },
      ),
    );
  }
}