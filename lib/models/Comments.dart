import 'package:cloud_firestore/cloud_firestore.dart';
class  Comment
{

  String uid;
  String postId;
  String profImage;
  String username;

  Comment({
    required this.username,
    required this.uid,
    required this.postId,
    required this.profImage,
  });
  Map<String,dynamic> toJson()=> {
    "username":username,
    "uid":uid,
    "postId":postId,
    "profImage":profImage,
  };

  static Comment fromSnap(DocumentSnapshot snapshot)
  {
    var snap = snapshot.data() as  Map<String,dynamic>;

    return Comment(
        uid: snap['uid'],
        username: snap['username'],
        profImage: snap['profImage'],
        postId: snap['postId'],
    );
  }
}