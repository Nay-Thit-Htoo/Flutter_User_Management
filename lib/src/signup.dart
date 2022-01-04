import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_management/env.dart';
import 'package:user_management/models/models.dart';
import 'package:user_management/src/Widget/signupContainer.dart';
import 'package:user_management/src/signin.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/global.dart' as global;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode? nameFocusNode, emailFocusNode, passwordFocusNode;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  Widget _nameWidget() {
    return Stack(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          controller: nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            // hintText: 'Enter your full name',
            labelText: 'Name',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailWidget() {
    return Stack(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          textInputAction: TextInputAction.next,
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Please enter a valid email",
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
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
          controller: passwordController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
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
          insertNewUser();
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Sign up',
            style: TextStyle(
                color: Colors.white,
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

  Widget _createLoginLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignInPage())),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
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
                height: MediaQuery.of(context).size.height * 1,
                child: const SignUpContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .4),
                        _nameWidget(),
                        const SizedBox(height: 20),
                        _emailWidget(),
                        const SizedBox(height: 20),
                        _passwordWidget(),
                        const SizedBox(height: 80),
                        _submitButton(),
                        SizedBox(height: height * .050),
                        _createLoginLabel(),
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

  Future<void> insertNewUser() async {
    if (nameController.text.isEmpty) {
      nameFocusNode?.requestFocus();
      return;
    }

    if (emailController.text.isEmpty) {
      emailFocusNode?.requestFocus();
      return;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 3) {
      passwordFocusNode?.requestFocus();
      return;
    }

    TipDialogHelper.loading("Please Wait");

    UserObj _user = UserObj();
    _user.name = nameController.text;
    _user.email = emailController.text;
    _user.password = passwordController.text;
    _user.roleType = "Admin";
    _user.isAdmin = true;
    Map body = _user.toJson();

    final headers = {'Content-Type': 'application/json'};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    http.Response response = await http.post(
      Uri.parse(Env.urlGetUserData),
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
      prefs.setBool('login', false);
      global.user = userFromJson(response.body);
      TipDialogHelper.dismiss();
      TipDialogHelper.success("Success");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignInPage()));
    } else {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'Warning',
          desc: response.body,
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            TipDialogHelper.dismiss();
          }).show();
    }
  }
}

class UserObj {
  String? name;
  String? email;
  String? password;
  String? roleType;
  bool? isAdmin;

  UserObj({this.name, this.email, this.password, this.roleType, this.isAdmin});

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "roleType": roleType,
        "isAdmin": isAdmin,
      };
}
