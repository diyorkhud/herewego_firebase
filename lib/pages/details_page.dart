import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_model.dart';
import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';
import '../services/stor_service.dart';
class DetailsPage extends StatefulWidget {
  static const String id = "details_page";
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var isLoading = false;

  File? _image;
  final picker = ImagePicker();

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
    if(_image==null) return;

    _apiUploadImage(firstName, lastName, content, date);
  }

  void _apiUploadImage(String firstName,String lastName,String content, String date) {
    setState((){
      isLoading = true;
    });

    StoreService.uploadImage(_image!).then((img_url) => {
      _apiAddPost(firstName, lastName, content, date, img_url!),
    });
  }


  _apiAddPost(String firstName, String lastName, String content, String date, String img_url) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id!, firstName, lastName, content, date, img_url)).then((response) => {
      _respAddPost(),
    });
  }

  _respAddPost(){
    setState((){
      isLoading = true;
    });

    Navigator.of(context).pop({"data":"done"});
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post",),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: _image != null ?
                      Image.file(_image!,fit: BoxFit.cover)
                          :Image.asset("assets/images/ic_camera.png",),
                    ),
                  ),
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
          isLoading ? const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
