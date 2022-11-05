import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';
class DetailsPage extends StatefulWidget {
  static const String id = "details_page";
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var contentController = TextEditingController();
  var dateController = TextEditingController();

  _addPost() async{
    String firstName = firstNameController.text.toString();
    String lastName = lastNameController.text.toString();
    String content = contentController.text.toString();
    String date = dateController.text.toString();
    if(firstName.isEmpty || lastName.isEmpty || content.isEmpty || date.isEmpty ) return;
    _apiAddPost(firstName, lastName, content, date);
  }

  _apiAddPost(String firstName, String lastName, String content, String date) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id!, firstName, lastName, content, date)).then((response) => {
      _respAddPost(),
    });
  }

  _respAddPost(){
    Navigator.of(context).pop({"data":"done"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post",),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 15,),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: "First Name",
                ),
              ),
              const SizedBox(height: 15,),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: "Last Name",
                ),
              ),
              const SizedBox(height: 15,),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: "Content",
                ),
              ),
              const SizedBox(height: 15,),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  hintText: "Date",
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 45,
                child: FlatButton(
                  onPressed: _addPost,
                  color: Colors.deepOrange,
                  child: const Text("Add",style: TextStyle(color: Colors.white,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
