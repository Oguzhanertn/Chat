import 'dart:io';
//import 'dart:js_interop';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  var p;

  StorageService();

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    Reference fileRef =
        _firebaseStorage.ref().child('users').child('pfps').child(uid);
    UploadTask task = fileRef.putFile(
        File(file.path), SettableMetadata(contentType: 'image/jpeg'));
    return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }

  Future<String?> uploadImageToChat(
      {required File file, required String chatID}) async {
    /*Reference fileRef = _firebaseStorage
        .ref('chats/$chatID')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );*/
    Reference fileRef = _firebaseStorage.ref().child('chats').child('$chatID');
    UploadTask task = fileRef.putFile(
        File(file.path), SettableMetadata(contentType: 'image/jpeg'));
    return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }
}
