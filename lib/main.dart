// Link DB: https://console.firebase.google.com/project/manager-device-in-room/database/manager-device-in-room-default-rtdb/data/~2F?fb_gclid=Cj0KCQjw0NPGBhCDARIsAGAzpp3Cs1n7D_yJ2dhnCUKxyBl5iLDx2RZvkhS-XNgCl4ShmXXGVNL1EDcaAtKuEALw_wcB

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {'login': (context) => mylogin()},
    );
  }
}
