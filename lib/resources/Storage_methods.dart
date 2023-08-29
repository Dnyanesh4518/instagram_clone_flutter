import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:uuid/uuid.dart';
class StorageMethods
{
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final metadata = SettableMetadata(contentType: 'image/jpeg');

  Future<String> uploadImageToStorage(String childName,Uint8List file,bool isPost) async
  {
    Reference reference = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost)
      {
        String id = const Uuid().v1();
         reference=reference.child(id);
      }
    try
    {
      final UploadTask uploadTask  = reference.putData(file,metadata);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    on firebase_core.FirebaseException catch(e)
    {
      return "Something wrong";
    }
  }
}