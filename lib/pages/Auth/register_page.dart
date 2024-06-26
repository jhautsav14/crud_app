import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/components/my_button.dart';
import 'package:crud_app/components/my_textfield.dart';
import 'package:crud_app/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  // register method

  void registerUser() async {
    print("rig");
    //show loading circlel̥
    showDialog(
      context: context, 
      builder: (context)=> const Center(
        child: CircularProgressIndicator(),
      )
    );

    // make sure the password  match
    if(passwordController.text != confirmpasswordController.text){
      //pop loading circle
      Navigator.pop(context);

      //show error message to user
      displayMessageToUser("Password don't match!", context);
    }

    // try create the user
    try {
      //create the user
      
      UserCredential? userCredential = 
        await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text
        );  

      // create a user doc and add to firestore
      createUserDocument(userCredential); 
      // pop the loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }
      
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      // display error message to user

      displayMessageToUser(e.code, context);
      
    }

  }

  // create user document and collect thrm in firestore

  Future<void> createUserDocument(UserCredential? userCredential) async{
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).
      set({
        'email': userCredential.user!.email,
        'username': usernameController.text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              // app logo
              Icon(
                Icons.fingerprint, 
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25,),
            
              //app name 
              const Text(
                "C R U D",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25,),
            
              // user textfield
              MyTextField(hintText: "Username", obscureText: false, controller: usernameController),
        
              const SizedBox(height: 10,),
            
              // email textfield
              MyTextField(hintText: "Email", obscureText: false, controller: emailController),
        
              const SizedBox(height: 10,),
            
              // password textfield
              MyTextField(hintText: "Password", obscureText: true, controller: passwordController),
              const SizedBox(height: 10,),
        
              // confirmpassword textfield
              MyTextField(hintText: "Confirm Password", obscureText: true, controller: confirmpasswordController),
              
              const SizedBox(height: 25,),
              // sign in button
        
              MyButton(text: "Register" , onTap:registerUser,),
              const SizedBox(height: 25,),
        
        
            
              // dont have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text("Login Here", style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
            
            
            ],
                  ),
          ),),
      ),
    );
  }
}