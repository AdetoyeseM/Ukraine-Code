import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app1234/data/models/follower.dart';
import 'package:flutter_app1234/data/models/subscriber.dart';
import 'package:flutter_app1234/data/models/user.dart';

abstract class UserReposetory {
  Future<UserModel> getUser(String uid);
  Future<UserModel> getUserById(String id);
  Future<List<UserModel>> getUsers(List<String> ids);
  Future<List<UserModel>> findUsers(String query);
  Future<List<FollowerModel>> getFollowers(String userId);
  Future<List<SubscriberModel>> getSubscription(String userId);
  Future<void> saveUser(UserModel user);
  Future<bool> isFollow(String currentUserId, String userId);
  Future<bool> subscribe(UserModel user, String userId);
  Future<bool> unsubscribe(UserModel user, String userId);
}

class FirebaseUserReposetory extends UserReposetory {
  @override
  Future<UserModel> getUser(String uid) async {
    final data = await Firestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .getDocuments();

    return UserModel()
      ..toObject({
        'id': data.documents[0].documentID,
        ...data.documents[0].data,
      });
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final data = await Firestore.instance.collection('user').document(id).get();

    return UserModel()
      ..toObject({
        'id': data.documentID,
        ...data.data,
      });
  }

  Future<List<UserModel>> getUsers(List<String> ids) async {
    final result = await Firestore.instance
        .collection('user')
        .where(FieldPath.documentId, whereIn: ids)
        .getDocuments();

    return result.documents
        .map((data) => UserModel()
          ..toObject({
            'id': data.documentID,
            ...data.data,
          }))
        .toList();
  }

  Future<List<UserModel>> findUsers(String query) async {
    final result = await Firestore.instance
        .collection('user')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .getDocuments();
    if (result.documents.length == 0) return [];
    return result.documents
        .map((data) => UserModel()
          ..toObject({
            'id': data.documentID,
            ...data.data,
          }))
        .toList();
  }

  @override
  Future<void> saveUser(UserModel user) {
    final ref = Firestore.instance.collection('user').document(user.id);
    return ref.updateData(user.toMap());
  }

  Future<List<FollowerModel>> getFollowers(String userId) async {
    final result = await Firestore.instance
        .collection('user')
        .document(userId)
        .collection('follower')
        .getDocuments();
    if (result.documents.length == 0) return [];
    return result.documents
        .map((e) => FollowerModel()..toObject(e.data))
        .toList();
  }

  Future<List<SubscriberModel>> getSubscription(String userId) async {
    final result = await Firestore.instance
        .collection('user')
        .document(userId)
        .collection('subscription')
        .getDocuments();

    if (result.documents.length == 0) return [];
    return result.documents
        .map((e) => SubscriberModel()..toObject(e.data))
        .toList();
  }

  Future<bool> isFollow(String currentUserId, String userId) async {
    final result = await Firestore.instance
        .collection('user')
        .document(currentUserId)
        .collection('subscription')
        .where('userId', isEqualTo: userId)
        .getDocuments();
    return result.documents.length > 0;
  }

  @override
  Future<bool> subscribe(UserModel user, String userId) async {
    var subscriptionRef = Firestore.instance
        .collection('user')
        .document(user.id)
        .collection('subscription')
        .reference();
    var followerRef = Firestore.instance
        .collection('user')
        .document(userId)
        .collection('follower')
        .reference();

    final subscription =
        await subscriptionRef.where('userId', isEqualTo: userId).getDocuments();
    final follower =
        await followerRef.where('userId', isEqualTo: user.id).getDocuments();
    if (subscription.documents.length > 0 || follower.documents.length > 0)
      return false;

    final followerUser = await getUserById(userId);
    user.subscriptions += 1;
    followerUser.followers += 1;
    await saveUser(user);
    await saveUser(followerUser);

    await subscriptionRef.add(SubscriberModel(userId: userId).toMap());
    await followerRef.add(FollowerModel(userId: user.id).toMap());
    return true;
  }

  @override
  Future<bool> unsubscribe(UserModel user, String userId) async {
    var subscriptionRef = Firestore.instance
        .collection('user')
        .document(user.id)
        .collection('subscription')
        .reference();
    var followerRef = Firestore.instance
        .collection('user')
        .document(userId)
        .collection('follower')
        .reference();

    final subscription =
        await subscriptionRef.where('userId', isEqualTo: userId).getDocuments();
    final follower =
        await followerRef.where('userId', isEqualTo: user.id).getDocuments();
    if (subscription.documents.length == 0 || follower.documents.length == 0)
      return false;

    final followerUser = await getUserById(userId);
    user.subscriptions -= 1;
    followerUser.followers -= 1;
    await saveUser(user);
    await saveUser(followerUser);

    await subscriptionRef
        .document(subscription.documents.first.documentID)
        .delete();
    await followerRef.document(follower.documents.first.documentID).delete();
    return true;
  }
}
