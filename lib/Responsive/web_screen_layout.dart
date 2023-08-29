import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_flutter/assets/global_variables.dart';
import '../assets/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout ({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}
class _WebScreenLayoutState extends State<WebScreenLayout> {
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
    setState(() {
      _page=page;
    });
  }
  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top:30),
          child: SvgPicture.asset(
            alignment: Alignment.bottomCenter,
            "lib/assets/images/ic_instagram.svg",
            color: Colors.black,
            height: 32,
          ),
        ),
        backgroundColor:primaryColor,
      ),
      body: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                  onTap:()=>navigationTapped(0),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20,right: 23),
                    child: Icon(Icons.home,
                      color: (_page == 0) ? Colors.black : secondaryColor,
                      size: 27,
                    ),
                  )),
              InkWell(
                  onTap: ()=>navigationTapped(1),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20,right: 23),
                    child: Icon(Icons.search,
                      color: (_page == 1) ? Colors.black : secondaryColor,
                      size: 27,
                    ),
                  )),
              InkWell(
                  onTap: ()=>navigationTapped(2),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20,right: 26),
                    child: Icon(Icons.add_a_photo,
                      color: (_page == 2) ? Colors.black : secondaryColor,
                      size: 24,
                    ),
                  )),
              InkWell(
                  onTap: ()=>navigationTapped(3),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20,right: 26),
                    child: Icon(Icons.add_box_outlined,
                      color: (_page == 3) ? Colors.black : secondaryColor,
                      size: 24,
                    ),
                  )),
              InkWell(
                  onTap:()=>navigationTapped(4),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20,right: 26),
                    child: Icon(Icons.person,
                      color: (_page == 4) ? Colors.black : secondaryColor,
                      size: 24,
                    ),
                  )),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: homeScreenItems,
            ),
          ),
        ],
      ),
    );
  }
}
