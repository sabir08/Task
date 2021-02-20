import 'package:egarage/dashboarsd.dart';
import 'package:egarage/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var phoneNo;
  var sms;
  var verificationId;

  final userData = GetStorage();
  @override
  void initState() {
    super.initState();

    userData.writeIfNull('isLoged', false);

    Future.delayed(Duration(seconds: 4), () async {
      checkifLogged();
    });
  }

  void checkifLogged() {
    userData.read('isLoged')
        ? Get.offAll(Dashboard())
        : Get.offAll(LoginScreen(
            phoneNo: phoneNo, sms: sms, verificationId: verificationId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 70,
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset('assets/images/eGrage11.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 150),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 70),
                  child: Column(
                    children: [
                      Text(
                        'eGarage',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'NotoSansKR',
                          letterSpacing: 1.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                      ),
                      Text(
                        'Digital Turn-in',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansKR',
                          letterSpacing: 3.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
