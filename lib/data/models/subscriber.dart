import 'model_base.dart';

class SubscriberModel extends ModelBase {
  String id; // Document ID
  String userId;

  SubscriberModel({this.id, this.userId});

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }

  @override
  void toObject(Map<String, dynamic> map) {
    userId = map['userId'];
  }
}
