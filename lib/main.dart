import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'data/firebase_service.dart';
import 'services/login.dart';
import 'services/qr_code.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDLe13nkbjdQkUYTqrOOo3T3WoJIWtHN6g",
      appId: "1:1077818876495:web:0092ca41a2e107fdf6c03a",
      messagingSenderId: "1077818876495",
      projectId: "bolinha-e9545",
      authDomain: "bolinha-e9545.firebaseapp.com",
      storageBucket: "bolinha-e9545.appspot.com",
    ),
  );
  await FirebaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gem Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      //home:  QRCodeGenerator(),
      home:  Login(),
    );
  }
}