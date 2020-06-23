import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app1234/data/models/post.dart';

abstract class PostReposetory {
  Future<List<PostModel>> getOlderPosts(int limit,
      {String lastDocumentId, String userId, bool showInvisiblePosts});
  Future<DocumentReference> addPost(PostModel post);
  Future<void> delete(PostModel post);
  Future<void> save(PostModel post);
}

class FirebasePostReposetory extends PostReposetory {
  @override
  Future<List<PostModel>> getOlderPosts(int limit,
      {String lastDocumentId,
      String userId,
      bool showInvisiblePosts = false}) async {
    var query = Firestore.instance
        .collection('post')
        .orderBy('createdAt', descending: true);

    if (!showInvisiblePosts) {
      query = query.where('visibility', isEqualTo: true);
    }
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    if (lastDocumentId != null) {
      final lastDocument = await Firestore.instance
          .collection('post')
          .document(lastDocumentId)
          .get();
      query = query.startAfterDocument(lastDocument);
    }
    query = query.limit(30);
    final result = await query.getDocuments();
    return result.documents
        .map((e) => PostModel()..toObject({...e.data, 'id': e.documentID}))
        .toList();
  }

  @override
  Future<DocumentReference> addPost(PostModel post) async {
    final document =
        await Firestore.instance.collection('post').add(post.toMap());
    return document;
  }

  @override
  Future<void> delete(PostModel post) {
    return Firestore.instance.collection('post').document(post.id).delete();
  }

  @override
  Future<void> save(PostModel post) {
    return Firestore.instance
        .collection('post')
        .document(post.id)
        .setData(post.toMap());
  }
}
