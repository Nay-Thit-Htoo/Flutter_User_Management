// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:user_management/src/Widget/signup_clipper.dart';

class SignUpContainer extends StatelessWidget {
  const SignUpContainer({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(color: Color(0xffff5E4d)),
          ),
        ),
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            height: MediaQuery.of(context).size.height * .55,
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(color: Color(0xff009B9B)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 150, horizontal: 20),
              child: Text('Create \nAccount!',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    // height: 5.5
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
