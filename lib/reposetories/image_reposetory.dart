import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

abstract class ImageReposetory {
  Future<String> uploadUserAvatar(String userId, File file);
  Future<List<String>> uploadPostImages(String postId, List<File> file);
  Future<void> uplaodGallaryImage(
      String username, String title, Uint8List data);
}

class FirebaseImageReposetory extends ImageReposetory {
  @override
  Future<String> uploadUserAvatar(String userId, File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user')
        .child(userId)
        .child('avatar');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(contentLanguage: 'en'),
    );
    final result = await uploadTask.onComplete;
    return await result.ref.getDownloadURL();
  }

  @override
  Future<String> getAvatarUrl(String userId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user')
          .child(userId)
          .child('avatar');

      final result = await ref.getDownloadURL();
      return result;
    } catch (ex) {
      return null;
    }
  }

  @override
  Future<List<String>> uploadPostImages(String postId, List<File> file) async {
    final tasks = file.map((file) async {
      final String uuid = Uuid().v1();
      final ref = FirebaseStorage.instance
          .ref()
          .child('post')
          .child(postId)
          .child(uuid);
      final StorageUploadTask uploadTask = ref.putFile(
        file,
        StorageMetadata(contentLanguage: 'en'),
      );
      final result = await uploadTask.onComplete;
      return await result.ref.getDownloadURL();
    });
    final result = await Future.wait(tasks);
    final imageUrls = result.map((e) => e as String).toList();
    return imageUrls;
  }

  @override
  Future<void> uplaodGallaryImage(
      String username, String title, Uint8List data) async {
    final String uuid = Uuid().v1();
    final ref = FirebaseStorage.instance
        .ref()
        .child('Users')
        .child(username)
        .child('Galleries')
        .child(title)
        .child(uuid);
    final StorageUploadTask uploadTask = ref.putData(
      data,
      StorageMetadata(contentLanguage: 'en'),
    );
    await uploadTask.onComplete;
  }
}
