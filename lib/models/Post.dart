import 'package:cloud_firestore/cloud_firestore.dart';
class  Post
{
  String description;
  String uid;
  String postId;
  String postURL;
  String profImage;
  String username;
  final DateTime datePublished;
  final likes;

  Post({
    required this.username,
    required this.description,
    required this.uid,
    required this.postId,
    required this.postURL,
    required this.profImage,
    required this.datePublished,
    required  this.likes
});
  Map<String,dynamic> toJson()=> {
    "username":username,
    "description":description,
    "uid":uid,
    "postId":postId,
    "postURL":postURL,
    "profImage":profImage,
    "likes":[],
    "datePublished":datePublished
      };

  static Post fromSnap(DocumentSnapshot snapshot)
  {
    var snap = snapshot.data() as  Map<String,dynamic>;

    return Post(
      uid: snap['uid'],
      username: snap['username'],
        datePublished: snap['datePublished'],
      description: snap['description'],
      profImage: snap['profImage'],
      postURL: snap['postURL'],
      postId: snap['postId'],
      likes: snap['likes']
    );
  }
}