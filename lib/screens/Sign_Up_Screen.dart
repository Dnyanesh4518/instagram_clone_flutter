import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import '../Custom_Widgets/text_field_input.dart';
import '../Responsive/mobile_screen_layout.dart';
import '../Responsive/responsive_layout_screen.dart';
import '../Responsive/web_screen_layout.dart';
import '../assets/colors.dart';
import '../assets/global_variables.dart';

class sign_up_screen extends StatefulWidget {
  const sign_up_screen({super.key});

  @override
  State<sign_up_screen> createState() => _sign_up_screenState();
}

class _sign_up_screenState extends State<sign_up_screen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void SelectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signupuser() async {
    setState(() {
      _isloading = true;
    });

    String res = await AuthMethods().SignUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!
    );
    setState(() {
      _isloading = false;
    });

    if (res == "success")
    {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const ResponsiveLayout(
          mobilescreenlayout: MobileScreenLayout(),
          webscreenlayout: WebScreenLayout()
      )));
    }
    else
    {
        showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ?EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3):
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: ListView(
            children: [
              const SizedBox(
                height: 34,
              ),
              SvgPicture.asset(
                "lib/assets/images/ic_instagram.svg",
                color: Colors.black,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              AssetImage("lib/assets/images/personimg.png"),
                        ),
                  Positioned(
                    left: 170,
                    bottom: -10,
                    child: IconButton(
                        onPressed: SelectImage,
                        icon: const Icon(Icons.add_a_photo,color: Colors.black,)),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _usernameController,
                  textInputType: TextInputType.text,
                  inputHintText: 'Enter your username'),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  inputHintText: 'Enter your Email'),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                textInputType: TextInputType.visiblePassword,
                inputHintText: 'Enter your password',
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _bioController,
                  textInputType: TextInputType.text,
                  inputHintText: 'Enter your bio'),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signupuser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : const Text("Sign Up"),
                ),
              ),
              InkWell(
                onTap: ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>LoginScreen())),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Already a user...",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
