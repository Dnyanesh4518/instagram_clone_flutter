import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Providers/user_provider.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'Responsive/mobile_screen_layout.dart';
import 'Responsive/responsive_layout_screen.dart';
import 'Responsive/web_screen_layout.dart';
import 'assets/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAtp3PyMg3QevTr0jQI_l3NHJxL3QekjrE",
      appId: "1:181507501383:web:db4a8c31b16ae8c152f062",
      messagingSenderId: "181507501383",
      projectId: "instagram-clone-569cc",
      storageBucket: "instagram-clone-569cc.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider(),)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: primaryColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    mobilescreenlayout: MobileScreenLayout(),
                    webscreenlayout: WebScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
