import 'package:crud_app/components/my_button.dart';
import 'package:crud_app/components/my_textfield.dart';
import 'package:crud_app/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login 
  void Login() async{

    // show loading screen

    showDialog(
      context: context, 
      builder: (context)=> const Center(
        child: CircularProgressIndicator(),
      )
    );

    // try sign in

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);

        // pop loading circle
      if(context.mounted) Navigator.pop(context);
      
    }  on FirebaseException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);

      
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
              const SizedBox(height: 50,),
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
            
            
              // email textfield
              MyTextField(hintText: "Email", obscureText: false, controller: emailController),
        
              const SizedBox(height: 10,),
            
              // password textfield
              MyTextField(hintText: "Password", obscureText: true, controller: passwordController),
              const SizedBox(height: 10,),
        
              // forgot password
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot password ?", style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
              const SizedBox(height: 25,),
              // sign in button
        
              MyButton(text: "Login" , onTap: Login,),
              const SizedBox(height: 25,),
        
        
            
              // dont have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text("Register Here", style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
            
            
            ],
                  ),
          ),),
      ),
    );
  }
}