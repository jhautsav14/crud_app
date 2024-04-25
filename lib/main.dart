import 'package:crud_app/firebase_options.dart';
import 'package:crud_app/pages/Auth/controller/auth.dart';
import 'package:crud_app/pages/Auth/controller/login_or_register.dart';
import 'package:crud_app/pages/Auth/login_page.dart';
import 'package:crud_app/pages/Auth/register_page.dart';
import 'package:crud_app/pages/home_page.dart';
import 'package:crud_app/pages/post_page.dart';
import 'package:crud_app/pages/profile_page.dart';
import 'package:crud_app/pages/users_page.dart';
import 'package:crud_app/theme/dark_mode.dart';
import 'package:crud_app/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CURD APP',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home:  const AuthPage(),

      routes: {
        '/login_registerr_page':(context) => const LoginOrRegister(),
        '/home_page':(context) => const HomePage(),
        '/profile_page':(context) =>  ProfilePage(),
        '/users_page':(context) => const UsersPage(),
        '/post_page':(context) =>  PostPage(),
      },
    );
  }
}
