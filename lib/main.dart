// Link DB: https://console.firebase.google.com/project/manager-device-in-room/database/manager-device-in-room-default-rtdb/data/~2F?fb_gclid=Cj0KCQjw0NPGBhCDARIsAGAzpp3Cs1n7D_yJ2dhnCUKxyBl5iLDx2RZvkhS-XNgCl4ShmXXGVNL1EDcaAtKuEALw_wcB

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/bedroom.dart'; // import class Bedroom từ file khác
import 'screens/livingroom.dart';
import 'screens/kitchen.dart';

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
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

// ------------------ Login Page ------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Login"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
    );
  }
}

// ------------------ Home Page ------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bed),
              title: const Text("Bedroom"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bedroom()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.living),
              title: const Text("Livingroom"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Livingroom()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.kitchen),
              title: const Text("Kitchen"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Kitchen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text("Welcome to Home Page")),
    );
  }
}
