import 'model_base.dart';

class UserModel extends ModelBase {
  String id; // Document ID
  String uid; // Auth User ID
  String username;
  String birthday;
  String website;
  String avatarUrl;
  int subscriptions;
  int followers;

  UserModel(
      {this.id,
      this.uid,
      this.username,
      this.birthday,
      this.website,
      this.avatarUrl,
      this.subscriptions = 0,
      this.followers = 0});

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'birthday': birthday,
      'website': website,
      'avatarUrl': avatarUrl,
      'subscriptions': subscriptions,
      'followers': followers,
    };
  }

  @override
  void toObject(Map<String, dynamic> map) {
    id = map['id'];
    uid = map['uid'];
    username = map['username'];
    birthday = map['birthday'];
    website = map['website'];
    avatarUrl = map['avatarUrl'];
    subscriptions = map['subscriptions'] ?? 0;
    followers = map['followers'] ?? 0;
  }
}
