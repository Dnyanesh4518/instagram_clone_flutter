import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String photoURL;
  final List followers;
  final List following;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.photoURL,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "bio": bio,
        "photoURL":photoURL,
        "following": following,
        "followers": followers
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
        uid: snap["uid"],
        username: snap["username"],
        email: snap["email"],
        photoURL: snap["photoURL"],
        followers: snap["followers"],
        following: snap["following"],
        bio: snap["bio"]??''
    );
  }
}
