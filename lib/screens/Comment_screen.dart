import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_clone_flutter/Custom_Widgets/Comments_Card.dart';
import 'package:instagram_clone_flutter/Providers/user_provider.dart';
import 'package:instagram_clone_flutter/assets/colors.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Comments ",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished',descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder:(context,index)=>CommentsCard(
                snap: snapshot.data!.docs[index].data(),
              ),
          );
    }
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 16),
                  child: TextField(
                    controller: _commentController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: "add a comment for ${widget.snap['username']}",
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.black,
                        border: InputBorder.none),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                      widget.snap['postId'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoURL);
                  setState(() {
                    _commentController.text="";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: blueColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
