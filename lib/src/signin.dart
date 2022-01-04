import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_management/env.dart';
import 'package:user_management/forgetPassword.dart';
import 'package:user_management/models/models.dart';
import 'package:user_management/src/Widget/fileAccess.dart';
import 'package:user_management/src/Widget/singinContainer.dart';
import 'package:user_management/src/Widget/userprofile.dart';
import 'package:user_management/src/signup.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/global.dart' as global;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode? emailFocusNode, passwordFocusNode;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  Future<void> userLogin() async {
    if (emailController.text.isEmpty) {
      emailFocusNode?.requestFocus();
      return;
    }

    if (passwordController.text.isEmpty) {
      passwordFocusNode?.requestFocus();
      return;
    }

    TipDialogHelper.loading("Please Wait");

    UserObj _user = UserObj();
    _user.email = emailController.text;
    _user.password = passwordController.text;
    Map body = _user.toJson();
    final SharedPreferences prefs = await _prefs;
    final headers = {
      'x-auth-token': prefs.getString('token').toString(),
      'Content-Type': 'application/json'
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    http.Response response = await http.post(
      Uri.parse(Env.urlLoginUser),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await _prefs;
      prefs.setString(
          'token',
          response.headers.entries
              .firstWhere((x) => x.key == 'x-auth-token')
              .value);
      prefs.setBool("login", true);
      TipDialogHelper.dismiss();
      TipDialogHelper.success("Success");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
      FileAccess.saveToFile(response.body);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserProfile()));
    } else {
      TipDialogHelper.dismiss();
      AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              headerAnimationLoop: false,
              animType: AnimType.TOPSLIDE,
              title: 'Login Alert',
              desc: response.body,
              btnCancelOnPress: () {},
              btnOkOnPress: () {})
          .show();
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 20, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailWidget() {
    return Stack(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          focusNode: emailFocusNode,
          textInputAction: TextInputAction.next,
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Please enter a valid email",
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
                color: Color.fromRGBO(173, 183, 192, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordWidget() {
    return Stack(
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          textInputAction: TextInputAction.next,
          controller: passwordController,
          focusNode: passwordFocusNode,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Color.fromRGBO(173, 183, 192, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          userLogin();
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Sign in',
            style: TextStyle(
                color: Color.fromRGBO(76, 81, 93, 1),
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1.6),
          ),
          SizedBox.fromSize(
            size: const Size.square(70.0), // button width and height
            child: const ClipOval(
              child: Material(
                color: Color.fromRGBO(76, 81, 93, 1),
                child: Icon(Icons.arrow_forward,
                    color: Colors.white), // button color
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage())),
            child: const Text(
              'Register',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPassword()));
            },
            child: const Text(
              'Forgot Password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery.of(context).size.height * 0.50,
                child: const SigninContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .55),
                        _emailWidget(),
                        const SizedBox(height: 20),
                        _passwordWidget(),
                        const SizedBox(height: 30),
                        _submitButton(),
                        SizedBox(height: height * .050),
                        _createAccountLabel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(top: 60, left: 0, child: _backButton()),
            TipDialogContainer(
                duration: const Duration(seconds: 2),
                outsideTouchable: true,
                onOutsideTouch: (Widget tipDialog) {
                  if (tipDialog is TipDialog &&
                      tipDialog.type == TipDialogType.LOADING) {
                    TipDialogHelper.dismiss();
                  }
                })
          ],
        ),
      ),
    );
  }
}
