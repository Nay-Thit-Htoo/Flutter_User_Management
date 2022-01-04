import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_management/src/Widget/userprofile.dart';
import 'package:user_management/src/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'User Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.grey,
        ),
        home: FutureBuilder(
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data! ? const UserProfile() : const SignInPage();
            } else {
              return const SignInPage();
            }
          },
          future: checkAlreadyUser(),
        ));
  }
}

Future<bool> checkAlreadyUser() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  if (prefs.getBool('login')!) {
    return true;
  } else {
    return false;
  }
}
