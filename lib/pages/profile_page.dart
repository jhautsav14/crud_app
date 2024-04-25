import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // current logged in user

  final User? currentUser = FirebaseAuth.instance.currentUser;

  //future to fetch user details
  Future <DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async{
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {

          // loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // error
          else if(snapshot.hasError){
            return Text("Error ${snapshot.error}");
          }

          // data recived
          else if (snapshot.hasData){
            // extract data
            Map<String, dynamic> ? user = snapshot.data!.data();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: ()=> Navigator.pop(context), 
                    icon: Icon(Icons.arrow_back_ios)
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white
                    ),
                    child: Icon(Icons.person, size: 80,)
                  ),
              
                  const SizedBox(height: 50, ),
                  Text(user!['username'], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                  Text(user['email']),


              
                  
                  
                  
                  
                ],
              ),
            );

          }else{
            return Text("No date");
          }
          
        },
      ),
      

    );
  }
}