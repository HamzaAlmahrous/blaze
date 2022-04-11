class SocialMessage{
  late String reciverId;
  late String senderId;
  late String text;
  late String dateTime;
  String? image;

  SocialMessage({ required this.reciverId, required this.dateTime, required this.senderId, this.image, required this.text});

  SocialMessage.fromJson(Map<String, dynamic> json){
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
  }

  Map<String, dynamic> toJson(){
    return {
      'reciverId' : reciverId,
      'dateTime' : dateTime,
      'text' : text,
      'senderId' : senderId,
      'image': image,
    };
  }
}