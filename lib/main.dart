import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hope/pages/auth_page.dart';
import 'package:hope/pages/login_page.dart';
import 'package:hope/pages/sign_up_page.dart';
import 'package:hope/upload/pdfUpload.dart';
import 'package:hope/upload/video_upload.dart';

import 'firebase_options.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home:uploadVideo(),
      //const AuthPage(),
    );
  }
}

