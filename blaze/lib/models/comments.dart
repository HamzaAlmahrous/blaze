class SocialComment{
  late String dateTime;
  late String uId;
  late String? cId;
  late String name;
  late String image;
  late String text;
  late String? commentImage;

  SocialComment({this.cId, required this.uId, required this.dateTime, required this.name, required this.image, this.commentImage, required this.text});

  SocialComment.fromJson(Map<String, dynamic> json){
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    commentImage = json['commentImage'];
    cId = json['cId'];
  }

  Map<String, dynamic> toJson(){
    return {
      'uId': uId,
      'dateTime': dateTime,
      'text': text,
      'name': name,
      'image': image,
      'commentImage': commentImage,
      'cId': cId,
    };
  }

}