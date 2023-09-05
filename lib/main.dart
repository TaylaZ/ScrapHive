import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scraphive/providers/user_provider.dart';
import 'package:scraphive/screens/default_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:scraphive/screens/login_screen.dart';
import 'package:scraphive/screens/signup_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import './screens/home_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ScrapHive',
        theme: ThemeData.light(),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const DefaultScreen();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    }
                  }

                  // If connection to future hasn't been made yet
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ScrapHiveLoader();
                  }

                  return const LoginScreen();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/ScrapHive_Logo.svg',
          height: 50,
        ),
      ),
    );
  }
}
