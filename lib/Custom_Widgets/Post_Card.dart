import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Providers/user_provider.dart';
import 'package:instagram_clone_flutter/assets/colors.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/screens/Comment_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone_flutter/models/users.dart';

import 'Like_Animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlength = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try
    {
      QuerySnapshot<Map<String,dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      commentlength=querySnapshot.docs.length;
    }
    catch(e)
    {
      showSnackBar(e.toString(), context);
      print(e.toString());
    }
    setState(() {

    });

  }

  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    Timestamp t = widget.snap['datePublished'];
    DateTime d = t.toDate();
    return Container(
      color: primaryColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // user.username.toString(),
                          widget.snap['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map((e) => InkWell(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList())));
                  },
                  icon: const Icon(Icons.more_vert_sharp),
                  color: Colors.black87,
                )
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image(image: NetworkImage("${widget.snap['postURL']}"),fit: BoxFit.contain,),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: likeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ]),
          ),
          // Like and comments section
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              likeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  iconSize: 29,
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border_outlined),
                  color: Colors.black,
                ),
              ),
              IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommentsScreen(snap: widget.snap)));
                  },
                  iconSize: 29,
                  color: Colors.black,
                  icon: Image.asset("lib/assets/images/bubble-chat.png")),
              IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  onPressed: () {},
                  iconSize: 27,
                  color: Colors.black,
                  icon: Image.asset(
                    "lib/assets/images/send (2).png",
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () {},
                  color: Colors.black,
                  iconSize: 29,
                ),
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                      child: Text('${widget.snap['likes'].length} likes'),
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 6),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            TextSpan(text: ""),
                            TextSpan(
                                text: '  ${widget.snap['description']}',
                                style: const TextStyle(color: Colors.black54))
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CommentsScreen(snap: widget.snap))),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text("view all $commentlength comments",
                        style: TextStyle(fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMEd().format(DateTime.parse(d.toString())),
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }
}
