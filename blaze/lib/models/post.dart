class SocialPost{
  late String name;
  late String dateTime;
  late String uId;
  late String text;
  late String image;
  late String? pId;
  String? postImage;
  int? likes;
  int? comments;

  SocialPost({this.pId, required this.name, required this.dateTime, required this.uId, this.postImage, required this.image, required this.text, this.comments, this.likes});

  SocialPost.fromJson(Map<String, dynamic> json){
    uId = json['uId'];
    name = json['name'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
    postImage = json['postImage'];
    likes = json['likes'];
    comments = json['comments'];
    pId = json['pId'];
  }

  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'dateTime' : dateTime,
      'text' : text,
      'uId' : uId,
      'image': image,
      'postImage': postImage,
      'likes': likes,
      'comments': comments,
      'pId': pId,
    };
  }
}