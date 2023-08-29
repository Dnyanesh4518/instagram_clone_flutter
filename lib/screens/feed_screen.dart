import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Custom_Widgets/Post_Card.dart';
import '../assets/colors.dart';
import '../assets/global_variables.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > webScreenSize
        ? Scaffold(
            body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot!.data!.docs.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: snapshot.data!.docs[index].data()),
              );
            },
          ))
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              elevation: 0,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SvgPicture.asset(
                  alignment: Alignment.bottomCenter,
                  "lib/assets/images/ic_instagram.svg",
                  color: Colors.black,
                  height: 32,
                ),
              ),
              backgroundColor: primaryColor,
              actions: [
                InkWell(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 23),
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color: Colors.black,
                    size: 27,
                  ),
                )),
                InkWell(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 26),
                  child: ImageIcon(
                    AssetImage("lib/assets/images/messenger.png"),
                    color: Colors.black,
                    size: 24,
                  ),
                )),
              ],
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot!.data!.docs.length,
                  itemBuilder: (context, index) =>
                      PostCard(snap: snapshot.data!.docs[index].data()),
                );
              },
            ));
  }
}
