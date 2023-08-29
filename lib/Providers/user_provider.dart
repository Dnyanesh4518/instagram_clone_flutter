import 'package:instagram_clone_flutter/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier
{
   User? _user;
   final AuthMethods _authMethods = AuthMethods();

   User get getUser => _user!;

   Future<void> refreshUser() async
   {
       User user = await  _authMethods.getUserDetails();
       print(user);
       _user = user;
       notifyListeners();
   }

}