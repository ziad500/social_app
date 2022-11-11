class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;
  String? postId;

  PostModel(
      {this.name,
      this.image,
      this.uId,
      this.postId,
      this.dateTime,
      this.postImage,
      this.text});

  PostModel.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    postId = json['postId'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uId": uId,
      "image": image,
      "postId": postId,
      "postImage": postImage,
      "text": text,
      "dateTime": dateTime
    };
  }
}
