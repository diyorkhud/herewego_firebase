
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';

import '../models/post_model.dart';

class RTDBService{
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>?> addPost(Post post)async{
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async {
    List<Post> items = [];

    Query query = _database.child("posts");
    await query.once().then((snapshot) {
      final v = snapshot.snapshot.children;
      for(var i in v){
        Map map = i.value as Map;
        items.add(Post(map['userId'],map['firstName'],map['lastName'],map['content'],map['date'],map['img_url']));
      }
    });
    return items;
  }
}