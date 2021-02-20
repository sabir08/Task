import 'package:egarage/dashboarsd.dart';
import 'package:egarage/methods/common%20method.dart';
import 'package:egarage/screens/registerscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyScreen extends StatefulWidget {
  final String phoneNo;
  final String sms;
  final String verificationId;
  final String verifyCompnyid;
  final String verifyEmployeeid;

  VerifyScreen({
    @required this.phoneNo,
    @required this.sms,
    @required this.verificationId,
    @required this.verifyCompnyid,
    @required this.verifyEmployeeid,
  });
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formkey = GlobalKey<FormState>();
  String smsCode;
  signIn() {
    // ignore: deprecated_member_use
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationId, smsCode: widget.sms);
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      ).catchError((e) => print(e));
    });
  }

  Future<void> registerAuth() async {
    var verifiID = widget.verificationId;
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      setState(() {
        print('Success');

        print(credential);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      print('${exception.message}');
    };

    final PhoneCodeSent phoneCode = (String veriId, [int forceCodesent]) {
      verifiID = veriId;
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String veriId) {
      verifiID = veriId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${this.widget.phoneNo}",
      timeout: const Duration(seconds: 20),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCode,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

//api for code

  String Url = 'https://www.egarage.in/api/register/mobile_verified';
  Future<void> verifyUser() async {
    String vCompnyId = widget.verifyCompnyid;
    String vEmployeeId = widget.verifyEmployeeid;
    var headers = {
      'token': 'b2905de7-0df5-44ee-f760-5a78be12e9d3',
      'key': 'ccdb973a-7b1e-4f52-e3b7-4e9e59dfac67',
      'application_id': '1',
      'company_id': vCompnyId,
      'employee_id': vEmployeeId,
    };

    final response = await http.post(Url, headers: headers);

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3.0,
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Phone Verification',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                    'We have sent a verification code on your phone number +91' +
                        widget.phoneNo,
                    style: TextStyle(
                      fontSize: 12,
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.dialpad,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              height: 70,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Enter Code..";
                                  }
                                },
                                onChanged: (value) {
                                  this.smsCode = value;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  labelText: 'Verification Code',
                                  labelStyle: TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              splashColor: Colors.white,
                              highlightColor: Colors.white,
                              onPressed: () {
                                registerAuth();
                              },
                              child: Text(
                                'Resend Code',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 0.6,
                                    offset: Offset(0.0, 3.0),
                                  )
                                ],
                              ),
                              child: FlatButton.icon(
                                height: 50,
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor)),
                                splashColor: Theme.of(context).accentColor,
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (_formkey.currentState.validate()) {
                                    print("Success");
                                  } else {
                                    print("not Success");
                                  }
                                  AuthCredential authCredential =
                                      // ignore: deprecated_member_use
                                      PhoneAuthProvider.getCredential(
                                          verificationId: widget.verificationId,
                                          smsCode: smsCode);
                                  FirebaseAuth.instance
                                      .signInWithCredential(authCredential)
                                      .then((user) {
                                    if (user != null) {
                                      addBoolvalue() async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setBool("isAlreadyMember", true);
                                      }

                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dashboard()));
                                      verifyUser();
                                    } else {
                                      Navigator.of(context).pop();
                                      signIn();
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                                label: Text(
                                  'VERIFY CODE',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 100),
                          child: Text('Problem receiving verification code?'),
                        ),
                        FlatButton(
                          padding: EdgeInsets.only(right: 253, bottom: 25.0),
                          color: Colors.white,
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          height: 5.0,
                          onPressed: () {},
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 15.0),
        width: double.infinity,
        height: 80,
        color: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dont worry your data will not be shared with anyone.Please read our',
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 11),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  height: 2,
                  padding: EdgeInsets.only(bottom: 20.0),
                  onPressed: () {},
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'and',
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
                FlatButton(
                  height: 2,
                  padding: EdgeInsets.only(bottom: 20.0, right: 16.0),
                  splashColor: Colors.black12,
                  onPressed: () {},
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
