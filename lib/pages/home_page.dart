import 'package:flutter/material.dart';

import '../services/auth_service.dart';
class HomePage extends StatefulWidget {
  static const String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      body: Center(
        child: FlatButton(
          onPressed: (){
            AuthService.signOutUser(context);
          },
          color: Colors.red,
          child: const Text("Logout", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
