import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';
import 'details_page.dart';
class HomePage extends StatefulWidget {
  static const String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>items=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }
  _openDetail() async{
    Map results = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context){
          return const DetailsPage();
        }
    ),);
    if(results !=null  && results.containsKey("data")){
      print(results["data"]);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async{
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id!).then((posts) => {
      _resPosts(posts),
    });
  }

  _resPosts(List<Post> posts){
    setState((){
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("All Posts"),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white,),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i){
          return itemOfList(items[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget itemOfList(Post post){
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${post.firstName} ${post.lastName}", style: const TextStyle(color: Colors.black, fontSize: 20),),
          const SizedBox(height: 10,),
          Text(post.date, style: const TextStyle(color: Colors.black, fontSize: 16),),
          const SizedBox(height: 10,),
          Text(post.content, style: const TextStyle(color: Colors.black, fontSize: 16),),
        ],
      ),
    );
  }
}
