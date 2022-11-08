class Post{
  String userId;
  String firstName;
  String lastName;
  String content;
  String date;
  String? img_url;

  Post(this.userId, this.firstName, this.lastName, this.content, this.date, this.img_url);

  Post.fromJson(Map<String ,dynamic>json)
      : userId = json['userId'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        content = json['content'],
        date = json['date'],
        img_url = json['img_url'];

  Map<String ,dynamic>toJson()=>{
    'userId':userId,
    'firstName':firstName,
    'lastName':lastName,
    'content':content,
    'date':date,
    'img_url':img_url,
  };
}