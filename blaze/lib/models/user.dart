class SocialUser{
  late String name;
  late String email;
  late String uId;
  late String phone;
  late String image;
  late String cover;
  late String bio;
  late int followers;

  SocialUser({required this.followers, required this.email, required this.name, required this.phone, required this.uId, required this.image, required this.bio, required this.cover});

  SocialUser.fromJson(Map<String, dynamic> json){
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    followers = json['followers'];
  }

  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'email' : email,
      'phone' : phone,
      'uId' : uId,
      'image': image,
      'cover': cover,
      'bio': bio,
      'followers': followers,
    };
  }

  SocialUser.empty(){
    uId = '-1';
    name = '';
    email = '';
    phone = '';
    image = '';
    bio = '';
    cover = '';
  }
}