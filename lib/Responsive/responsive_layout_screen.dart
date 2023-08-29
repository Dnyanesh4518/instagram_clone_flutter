import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../assets/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobilescreenlayout;
  final Widget webscreenlayout;
  const ResponsiveLayout(
      {super.key,
      required this.mobilescreenlayout,
      required this.webscreenlayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}
class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }
  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();

  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webscreenlayout;
      } else {
        return widget.mobilescreenlayout;
      }
    });
  }
}
