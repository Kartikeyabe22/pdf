import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hope/pages/home_page.dart';
import 'package:hope/pages/login_or_signup.dart';
import 'package:hope/pages/login_page.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot){
        if(snapshot.connectionState== ConnectionState.waiting){//for any internet issue
          return const CircularProgressIndicator();
        } else{
          if (snapshot.hasData){
            return  HomePage();
          } else{
            return const LoginAndSignUp();
          }
        }
        },
      )

    );
  }
}
