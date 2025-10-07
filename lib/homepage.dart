import 'package:flutter/material.dart';
import 'screens/bedroom.dart'; // import class Bedroom từ file khác
import 'screens/livingroom.dart';
import 'screens/kitchen.dart';
// import 'local_auth.dart';
import 'login.dart'; // để logout quay về màn hình login (mylogin)

// ------------------ Home Page ------------------
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key,  required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => mylogin()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),  // Sửa icons.logout -> Icons.logout
            // color: Colors.red,
            tooltip: 'Logout',
          ),
        ],
        title: const Center (
          child: Text("M Y H O M E", style: TextStyle(fontWeight: FontWeight.w600),),),
        backgroundColor: const Color.fromRGBO(195, 210, 255, 1), 
      ),
      drawer: Drawer (
        child: Container(
          color: const Color.fromRGBO(195, 210, 255, 1),
          child: ListView(
            children: [
              DrawerHeader(
                child: Center (
                  child: Text("H O M E", style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700),)
                )
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home", style: TextStyle(fontSize: 25),),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage(title: '',)));
                },
              ),
              ListTile(
                leading: Icon(Icons.living),
                title: Text("Livingroom", style: TextStyle(fontSize: 25),),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Livingroom()));
                },
              ),
              ListTile(
                leading: Icon(Icons.bed),
                title: Text("Bedroom", style: TextStyle(fontSize: 25),),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Bedroom()));
                },
              ),
              ListTile(
                leading: Icon(Icons.kitchen),
                title: Text("Kitchen", style: TextStyle(fontSize: 25),),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Kitchen()));
                },
              ),
            ],
          ),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ảnh từ assets
            Image.asset(
              'img/Home.png', 
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Image.asset(
              'img/Livingroom.png', 
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Image.asset(
              'img/Kitchen.png', 
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Image.asset(
              'img/Bed.png', 
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
        ],),
      ),
    );
  }
}