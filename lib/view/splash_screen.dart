import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task/view/bottom_bar.dart';
import 'package:task/view/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? uId;

  @override
  void initState() {
    userId().whenComplete(() => Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  uId == null ? SignUpScreen() : BottomBarScreen(),
            ),
          );
        }));
    super.initState();
  }

  final getStorage = GetStorage();

  Future userId() async {
    String userId = await getStorage.read("Email");

    setState(() {
      uId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.1),
                Colors.grey.shade200,
                Colors.grey.shade200,
                Colors.grey.shade200,
                Colors.greenAccent.withOpacity(0.1)
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd),
        ),
        child: Center(
          child: Image.asset(
            "assets/extra.png",
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
