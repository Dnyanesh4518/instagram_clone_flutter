import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/assets/colors.dart';
import 'package:instagram_clone_flutter/assets/global_variables.dart';
import 'package:provider/provider.dart';

import '../Providers/user_provider.dart';
import '../models/users.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;
  @override
  void initState() {
    pageController=PageController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
  void navigationTapped(int page) {
       pageController.jumpToPage(page);
  }
  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children:homeScreenItems,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: (_page == 0) ? Colors.black : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              color: (_page == 1) ? Colors.black : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("lib/assets/images/more.png"),size: 25,
              color: (_page == 2) ? Colors.black : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("lib/assets/images/video.png"),size: 25,
              color: (_page == 3) ? Colors.black : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
              radius: 16,
            ),
            // Icon(
            //   Icons.person,
            //   color: (_page == 4) ? Colors.black : secondaryColor,
            // ),
            label: '',
            backgroundColor: primaryColor),
      ],
      iconSize: 32,
      activeColor: Colors.black,
      inactiveColor: secondaryColor,
      backgroundColor: primaryColor,
      onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
