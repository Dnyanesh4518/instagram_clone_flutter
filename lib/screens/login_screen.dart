import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_flutter/Custom_Widgets/text_field_input.dart';
import 'package:instagram_clone_flutter/Responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/Responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/assets/global_variables.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:instagram_clone_flutter/screens/Sign_Up_Screen.dart';
import '../Responsive/responsive_layout_screen.dart';
import '../assets/colors.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  void loginUser() async {
    String res = await AuthMethods().loginUser(email: _emailController.text, password:_passwordController.text);
    if(res!="success"){
        showSnackBar(res, context);
      }
    Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>ResponsiveLayout(mobilescreenlayout:MobileScreenLayout(), webscreenlayout: WebScreenLayout())));
  }
  void navigateToSignUpScreen()  {
    Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>sign_up_screen()));
  }
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ?EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
            const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child:Container(),flex: 2,),
                SvgPicture.asset("lib/assets/images/ic_instagram.svg",color:Colors.black,height: 64,),
                const SizedBox(height: 64,),
                TextFieldInput(textEditingController:_emailController, textInputType: TextInputType.emailAddress, inputHintText:'Enter your Email'),
                const SizedBox(height: 24,),
                TextFieldInput(textEditingController: _passwordController, textInputType: TextInputType.visiblePassword, inputHintText: 'Enter your password',isPass:true,),
                const SizedBox(height: 24,),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    child: const Text("Login"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
                  ),
                ),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Don't have Account ",style: TextStyle(color: Colors.black),),
                    ),
                    GestureDetector (
                      onTap: navigateToSignUpScreen,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                    )
                  ],
                ),
                Flexible(child:Container(),flex: 2,),
              ],
            ),
          )),
    );
  }
}
