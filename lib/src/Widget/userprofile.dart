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
import 'package:user_management/userprofile_edit.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<User> userList = List.empty(growable: true);
  late Future<String> future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = getUserListByAdimn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: FutureBuilder<String>(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data == "success") {
              return Scaffold(
                appBar: AppBar(
                    backgroundColor: const Color(0xff009B9B),
                    toolbarHeight: 90,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/4333/4333609.png'),
                              backgroundColor: Colors.transparent,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " ${global.user!.name.toString()} ( ${global.user!.role!.roleType.toString()} )",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  global.user!.email!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                body: Stack(children: [
                  if (userList.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Registered User List',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(userList.length.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        padding: const EdgeInsets.only(top: 35),
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 2, left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  offset: Offset(1, 1), // Shadow position
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userList[index].name.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      userList[index].email.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileEdit(
                                                    user: userList[index])));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff009B9B),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.edit,
                                          size: 24, color: Colors.white),
                                    ),
                                  ),
                                ),
                                if (global.user?.id != userList[index].id)
                                  GestureDetector(
                                    onTap: () {
                                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.INFO,
                                          headerAnimationLoop: false,
                                          animType: AnimType.TOPSLIDE,
                                          title: 'Delete Alert',
                                          desc: "Are you sure to delete?",
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            deleteUserbyAdmin(
                                                userList[index].id.toString());
                                          }).show();
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.redAccent,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.delete,
                                            size: 24, color: Colors.white),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        })
                  ] else
                    const Center(
                      child: Text('Empty User List'),
                    ),
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
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.logout_rounded),
                  onPressed: () {
                    logOut();
                  },
                ),
              );
            } else {
              return Scaffold(
                  body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: const Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: "Please Wait",
                        backgroundColor: Colors.white,
                        color: Color(0xff009B9B),
                      ),
                    ),
                  )
                ],
              ));
            }
          }),
    );
  }

  Future<String> getUserListByAdimn() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    var queryParameters;
    await FileAccess.readFromFile().then((value) {
      global.user = userFromJson(value);
    }).then((value) => queryParameters = {
          'isAdmin': global.user?.isAdmin,
        });

    final headers = {
      'x-auth-token': prefs.getString('token').toString(),
      'Content-Type': 'application/json'
    };
    String jsonBody = json.encode(queryParameters);
    final encoding = Encoding.getByName('utf-8');
    http.Response response = await http.post(
      Uri.parse(Env.urlGetUserList),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    if (response.statusCode == 200) {
      setState(() {
        userList = userListFromJson(response.body);
      });
      if (userList.isNotEmpty) {
        return "success";
      } else {
        return "error";
      }
    } else {
      return "error";
    }
  }

  Future<void> deleteUserbyAdmin(String userId) async {
    TipDialogHelper.loading("Deleting");
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    final queryParameters = {
      'isAdmin': global.user?.isAdmin,
    };
    final headers = {
      'x-auth-token': prefs.getString('token').toString(),
      'Content-Type': 'application/json'
    };
    String jsonBody = json.encode(queryParameters);
    final encoding = Encoding.getByName('utf-8');
    http.Response response = await http.post(
      Uri.parse(Env.urlDeleteUser + "/" + userId),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    if (response.statusCode == 200) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("Success");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
      setState(() {
        userList = userListFromJson(response.body);
      });
    } else {
      TipDialogHelper.dismiss();
      TipDialogHelper.fail("Failed");
      await Future.delayed(const Duration(seconds: 2));
      TipDialogHelper.dismiss();
    }
  }

  Future<void> logOut() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("login", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
  }
}
