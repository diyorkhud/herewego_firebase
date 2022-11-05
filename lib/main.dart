import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/details_page.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/pages/signup_page.dart';
import 'package:herewego/services/prefs_service.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          Prefs.saveUserId(snapshot.data.uid);
          return const HomePage();
        }else{
          Prefs.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: _startPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUp.id: (context) => const SignUp(),
        DetailsPage.id: (context) => const DetailsPage(),
      },
    );
  }
}
