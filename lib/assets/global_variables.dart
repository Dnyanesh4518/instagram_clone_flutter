import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/ProfileScreen.dart';
import 'package:instagram_clone_flutter/screens/SearchScreen.dart';
import 'package:instagram_clone_flutter/screens/add_post_screen.dart';
import 'package:instagram_clone_flutter/screens/feed_screen.dart';

    const  webScreenSize=600;
    List<Widget>homeScreenItems =[
      FeedScreen(),
      SearchScreen(),
      AddPostScreen(),
      Text("notify"),
      ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
    ];