import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/screens/login_screen.dart';
import 'package:scraphive/screens/signup_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/utils/mobile_screen_layout.dart';
import 'package:scraphive/utils/responsive_layout.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import 'package:scraphive/utils/web_screen_layout.dart';
import './screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAoY6FjMUJI0Mi3Y5iFo6v2nZZdISNq3Mc',
        appId: '1:832603393496:web:15000db4e98e22df9736ad',
        messagingSenderId: '832603393496',
        projectId: 'scraphive-test',
        storageBucket: 'scraphive-test.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScrapHive',
      theme: ThemeData.light(),
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: mobileBackgroundColor,
      // ),
      // home: const HomeScreen(),
      // home: ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),

      home: SignupScreen(),
    );
  }
}
