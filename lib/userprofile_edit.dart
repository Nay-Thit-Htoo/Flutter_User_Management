import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_management/env.dart';
import 'package:user_management/global.dart' as global;
import 'package:user_management/main.dart';
import 'package:user_management/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:user_management/src/Widget/fileAccess.dart';
import 'package:user_management/src/Widget/userprofile.dart';
import 'package:user_management/src/signin.dart';

class UserProfileEdit extends StatefulWidget {
  const UserProfileEdit({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  List<User> userList = List.empty(growable: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.user.name.toString();
    emailController.text = widget.user.email.toString();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Column(children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfile()));
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(left: 15, right: 50),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 24, color: Colors.black),
                    ),
                  ),
                ),
                const Text(
                  "User Profile Edition",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                readOnly: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: emailController,
                readOnly: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                focusNode: passwordFocus,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: confirmPasswordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                focusNode: confirmPasswordFocus,
                decoration: const InputDecoration(
                  labelText: 'Confrim Password',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff009B9B), width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    updateUserInformation();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      color: const Color(0xff009B9B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("Change",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    passwordController.clear();
                    confirmPasswordController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("Cancel",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ),
                ),
              ],
            )
          ]),
          TipDialogContainer(
              duration: const Duration(seconds: 2),
              outsideTouchable: true,
              onOutsideTouch: (Widget tipDialog) {
                if (tipDialog is TipDialog &&
                    tipDialog.type == TipDialogType.LOADING) {
                  TipDialogHelper.dismiss();
                }
              })
        ]),
      ),
    );
  }

  Future<void> updateUserInformation() async {
    FocusScope.of(context).unfocus();
    if (passwordController.text.isEmpty) {
      passwordFocus.requestFocus();
      return;
    } else if (passwordController.text.length < 5) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              title: 'Alert',
              desc: "Password Length must be at least 5",
              btnCancelOnPress: () {},
              btnOkOnPress: () {})
          .show();
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordFocus.requestFocus();
      return;
    } else if (confirmPasswordController.text.length < 5) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              title: 'Alert',
              desc: "Password Length must be at least 5",
              btnCancelOnPress: () {},
              btnOkOnPress: () {})
          .show();
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              title: 'Alert',
              desc: "Password does not match",
              btnCancelOnPress: () {},
              btnOkOnPress: () {})
          .show();
      return;
    }

    TipDialogHelper.loading("Updating");
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final queryParameters = {
      'name': widget.user.name.toString(),
      'email': widget.user.email.toString(),
      'password': passwordController.text.toString(),
      'isAdmin': widget.user.isAdmin
    };
    final headers = {
      'x-auth-token': prefs.getString('token').toString(),
      'Content-Type': 'application/json'
    };
    String jsonBody = json.encode(queryParameters);
    final encoding = Encoding.getByName('utf-8');
    http.Response response = await http.put(
      Uri.parse(Env.urlUpdateUser + "/" + widget.user.id.toString()),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    if (response.statusCode == 200) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("Success");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setBool("login", false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignInPage()));
    } else {
      TipDialogHelper.dismiss();
      TipDialogHelper.fail("Fail");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
    }
  }
}
