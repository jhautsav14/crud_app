import 'package:crud_app/pages/Auth/controller/login_or_register.dart';
import 'package:crud_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // user is logged in
        if(snapshot.hasData){
          return const HomePage();
        }else{
          return const LoginOrRegister();
        }
      },
    );
  }
}