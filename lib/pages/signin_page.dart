import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/signup_page.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/utils_service.dart';
import 'home_page.dart';
class SignInPage extends StatefulWidget {
  static const String id = "login_page";
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doLogIn(){
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty) {
      setState((){
        isLoading = true;
      });
      return AuthService.signInUser(context, email, password).then((firebaseUser) => {
        _getFirebaseUser(firebaseUser!),
      });
    }
  }

  _getFirebaseUser(User firebaseUser){
    setState((){
      isLoading = true;
    });
    if(firebaseUser!=null){
      Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Utils.fireToast("Check your email or password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email"
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: "Password"
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    color: Colors.red,
                    onPressed: _doLogIn,
                    child: const Text("Sign In", style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, SignUp.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text("Don't have an account?", style: TextStyle(color: Colors.black),),
                        SizedBox(height: 10,),
                        Text("Sign Up", style: TextStyle(color: Colors.black),),
                      ],
                    ),

                  ),
                ),
              ],
            ),
          ),
          isLoading?
          const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
