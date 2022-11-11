class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? bio;
  String? cover;

  String? passsord;
  bool? isEmailVerified;
  UserModel(
      {this.email,
      this.name,
      this.bio,
      this.cover,
      this.passsord,
      this.image,
      this.phone,
      this.uId,
      this.isEmailVerified});

  UserModel.fromjson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    bio = json['bio'];
    cover = json['cover'];
    image = json['image'];
    phone = json['phone'];
    passsord = json['password'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": passsord,
      "bio": bio,
      "uId": uId,
      "cover": cover,
      "image": image,
      "isEmailVerified": isEmailVerified,
    };
  }
}
