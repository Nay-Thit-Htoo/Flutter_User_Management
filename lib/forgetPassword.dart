// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:user_management/env.dart';
import 'package:user_management/global.dart';
import 'package:user_management/src/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
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
                            builder: (context) => const SignInPage()));
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
                  "Forget Password",
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
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                focusNode: emailFocus,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    sendEmailWithUserInfo();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      color: const Color(0xff009B9B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("Send",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    emailController.clear();
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

  Future<void> sendEmailWithUserInfo() async {
    FocusScope.of(context).unfocus();
    if (emailController.text.isEmpty) {
      emailFocus.requestFocus();
      return;
    }

    TipDialogHelper.loading("Please Wait");
    final headers = {'Content-Type': 'application/json'};
    http.Response response = await http.get(
      Uri.parse(Env.urlForgetPassword + "/" + emailController.text.toString()),
      headers: headers,
    );
    if (response.statusCode == 200) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("Success");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
    } else {
      TipDialogHelper.dismiss();
      TipDialogHelper.fail("Fail");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
    }
  }
}
