import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/signin_page.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/utils_service.dart';
import 'home_page.dart';
class SignUp extends StatefulWidget {
  static const String id = "signup_page";
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var isLoading = false;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){
    String name = nameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    setState((){
      isLoading = true;
    });

    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });
  }

  _getFirebaseUser(User firebaseUser) async{
    setState((){
      isLoading = false;
    });

    if(firebaseUser!=null){
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Utils.fireToast("Check your information.");
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
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: "Full name"
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email"
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  obscureText: true,
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
                    onPressed: _doSignUp,
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, SignInPage.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text("Already have an account?", style: TextStyle(color: Colors.black),),
                        SizedBox(height: 10,),
                        Text("Sign In", style: TextStyle(color: Colors.black),),
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
