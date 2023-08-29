import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/assets/global_variables.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/screens/Sign_Up_Screen.dart';
import 'package:provider/provider.dart';
import '../Custom_Widgets/FollowButton.dart';
import '../Providers/user_provider.dart';
import '../models/users.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var Postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = usersnap.data()!;
      postLen = Postsnap.docs.length;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      isFollowing = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  leadingWidth: 24,
                  iconTheme: IconThemeData(color: Colors.black),
                  toolbarHeight: 54,
                  backgroundColor: Colors.white,
                  title: Text(
                    userData['username'],
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                  centerTitle: false,
                  elevation: 0,
                    actions: width >webScreenSize?[]:[
                       IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.dehaze,
                          color: Colors.black,
                        ))
                  ],

                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      NetworkImage(userData['photoURL']),
                                  radius: 41,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          buildStateColumn(postLen, "Posts"),
                                          buildStateColumn(followers, "Followers"),
                                          buildStateColumn(following, "Following"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FirebaseAuth.instance.currentUser!
                                                      .uid ==
                                                  widget.uid
                                              ?
                                          Row(
                                                children: [
                                                  // FollowButton(
                                                  //     function: () {},
                                                  //     backgroundColor: Colors.blue,
                                                  //     borderColor: Colors.blue,
                                                  //     text: 'Edit Profile',
                                                  //     textColor: Colors.white,
                                                  //   ),
                                                  Container(
                                                      width: 130,
                                                      height: 35,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                          backgroundColor: Colors.blue),
                                                      onPressed: () {
                                                        AuthMethods().logoutUser();
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => sign_up_screen()));
                                                      },
                                                      child: Text("Logout",style: TextStyle(fontSize: 18),),
                                                    ),
                                                  ),
                                                ],
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              )
                                              : isFollowing
                                                  ? FollowButton(
                                                      function: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                userData[
                                                                    'uid']);
                                                        setState(() {
                                                          isFollowing=false;
                                                          followers--;
                                                        });
                                                      },
                                                      backgroundColor:
                                                          Colors.white,
                                                      borderColor: Colors.black,
                                                      text: 'Following',
                                                      textColor: Colors.black,
                                                    )
                                                  : FollowButton(
                                                      function: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData[
                                                            'uid']);
                                                        setState(() {
                                                          isFollowing=true;
                                                          followers++;
                                                        });
                                                      },
                                                      backgroundColor:
                                                          Colors.blue,
                                                      borderColor: Colors.white,
                                                      text: 'Follow',
                                                      textColor: Colors.white,
                                                    )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 12),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                userData['username'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black),
                              )),
                          Container(
                              padding: EdgeInsets.only(left: 12),
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: userData['bio'],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ]),
                              )),
                          Container(
                            padding: EdgeInsets.only(left: 12),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              userData['email'],
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                return Container(
                                  child: Image(
                                      image: NetworkImage(
                                        snap['postURL'],
                                      ),
                                      fit: BoxFit.cover),
                                );
                              });
                        })
                  ],
                )),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ))
      ],
    );
  }
}
