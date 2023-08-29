import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/Post.dart';
import 'Storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost (
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage
      )
  async {
    String res = "some error has occured";
    try{
      String photourl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          username: username,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          postURL: photourl,
          profImage: profImage,
          likes: []
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res='success';
    }
    catch(err)
    {
      res=err.toString();
    }
    return res;

  }

  Future<void> likePost(String postId,String uid,List likes) async
  {
     try
         {
           if(likes.contains(uid))
               {
                await  _firestore.collection('posts').doc(postId).update({
                   'likes':FieldValue.arrayRemove([uid])
                 });
               }
           else
             {
               {
                await _firestore.collection('posts').doc(postId).update({
                   'likes':FieldValue.arrayUnion([uid])
                 });
               }
             }

         }
         catch(e)
    {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId,String text,String uid,String name,String profilePic) async
  {
    try{
      if(text.isNotEmpty)
        {
           String commentId = const Uuid().v1();
        await   _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
             'profilePic':profilePic,
             'name':name,
             'text':text,
             'uid':uid,
             'datePublished':DateTime.now()
          });
        }
      else
        {
          print("text is empty");
        }

    }catch(e)
    {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid,String followId) async{
    try
  {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
    List following = (snapshot.data()! as dynamic)['following'];
    if(following.contains(followId))
      {
        await _firestore.collection('users').doc(followId).update({
          'followers':FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])});
      }
      else
        {
        await _firestore.collection('users').doc(followId).update({
        'followers':FieldValue.arrayUnion([uid])});
        await _firestore.collection('users').doc(uid).update({
        'following':FieldValue.arrayRemove([followId])});
        }
  }catch(e)
  {
    print(e.toString());
  }
}
}