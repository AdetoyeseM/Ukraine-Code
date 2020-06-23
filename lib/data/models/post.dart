import 'model_base.dart';

class PostModel extends ModelBase {
  String id;
  String userId;
  String text;
  int createdAt;
  bool visibility;
  List<String> photos;

  PostModel(
      {this.userId,
      this.text,
      this.createdAt,
      this.photos,
      this.visibility = true});

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'createdAt': createdAt,
      'photos': photos,
      'visibility': visibility,
    };
  }

  @override
  void toObject(Map<String, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    text = map['text'];
    createdAt = map['createdAt'];
    if (map['photos'] != null) photos = List<String>.from(map['photos']);
    visibility = map['visibility'];
  }
}
