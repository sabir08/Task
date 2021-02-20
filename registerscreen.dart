import 'dart:convert';

import 'package:egarage/apiintegration/register.dart';
import 'package:egarage/apiintegration/responsepodo.dart';
import 'package:egarage/methods/common%20method.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:egarage/screens/loginscreen.dart';
import 'package:egarage/screens/verifyscreen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userData = GetStorage();
  String mCompanyId;
  String mEmployeeId;

  var _formKey = GlobalKey<FormState>();
  bool _isShowPassword = true;

  void _openPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyScreen(
                  phoneNo: phoneNo,
                  sms: sms,
                  verificationId: verificationId,
                  verifyCompnyid: mCompanyId,
                  verifyEmployeeid: mEmployeeId,
                )));
  }

  Future<bool> get smsCodeSent async {
    _openPage();
  }

  TextEditingController WorkshopName = TextEditingController();
  TextEditingController OwnerName = TextEditingController();
  TextEditingController EmailAddress = TextEditingController();
  TextEditingController PhoneNumber = TextEditingController();
  TextEditingController Password = TextEditingController();

  String url = 'https://www.egarage.in/api/register';
  Future<RegisterInfo> regiesterUser() async {
    var headers = {
      'token': 'b2905de7-0df5-44ee-f760-5a78be12e9d3',
      'key': 'ccdb973a-7b1e-4f52-e3b7-4e9e59dfac67',
      'application_id': '1'
    };

    final body = {
      'workshop_name': WorkshopName.text,
      'owner_name': OwnerName.text,
      'password': Password.text,
      'timezone_id': 'Asia/Kolkata',
      'country_code': '91',
      'device_id': getDeviceDetails().toString(),
      'login_type': 'flutter',
      'owner_email': EmailAddress.text,
      'phone_number': PhoneNumber.text
    };

    final response = await http.post(url, headers: headers, body: body);
    print(response.body);
    String regster = response.body;
    var data = RegisterInfo.fromJson(json.decode('$regster'));

    if (response.statusCode == 200) {
      print("Url Successful" + response.body);

      mCompanyId = data.result.companyId.toString();
      mEmployeeId = data.result.employeeId.toString();

      if (data.result.verified == "0") {
        _submit();
      } else {
        print(response.body);
      }
    } else {
      print(data.msg);
      throw Exception(data.msg);
    }
  }

  Future<Loginfo> sharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('verificationId', verificationId = verificationId);
    prefs.setString('sms', sms = sms);
    setState(() {
      verificationId = verificationId;
      sms = sms;
    });
  }

  String phoneNo;
  String verificationId;
  String sms;

  Future<void> _submit() async {
    print(verificationId);
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
      this.verificationId = veriId;
      smsCodeSent.then((value) {
        print('Signed In');
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String veriId) {
      this.verificationId = veriId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${this.phoneNo}",
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCode,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'eGarage',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Helps you boost Business With feature-rich Garage Management System',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                top: 50,
              )),
              Center(
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  width: double.infinity,
                  height: 650,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.store,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 70,
                                child: TextFormField(
                                  controller: WorkshopName,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Please Enter a WorkshopName";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: 'Workshop Name',
                                    labelStyle: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.title,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 70,
                                child: TextFormField(
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Please Enter a OwnerName";
                                    }
                                    return null;
                                  },
                                  controller: OwnerName,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: 'Owner Name',
                                    labelStyle: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.alternate_email,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 70,
                                child: TextFormField(
                                  controller: EmailAddress,
                                  validator: validatEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: 'E-mail Address',
                                    labelStyle: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 20.0,
                          )),
                          Container(
                            padding: EdgeInsets.only(
                              right: 220,
                              bottom: 20,
                            ),
                            child: Text(
                              'Login Details',
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.flag,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 70,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: '+91(INDIA)',
                                    enabled: false,
                                    labelStyle: TextStyle(
                                        fontSize: 14.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.expand_more,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.call_sharp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 70,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      this.phoneNo = value;
                                    });
                                  },
                                  controller: PhoneNumber,
                                  validator: validateMobile,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: 'Phone Number | Employee ID',
                                    labelStyle: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.vpn_key,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 70,
                                child: TextFormField(
                                  controller: Password,
                                  validator: validatPassword,
                                  obscureText: _isShowPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: _togglePasswordView,
                                  child: _isShowPassword
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 0.6,
                                  offset: Offset(2.4, 3.5),
                                )
                              ],
                            ),
                            child: FlatButton(
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  'CREATE NEW ACCOUNT',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    regiesterUser();
                                    userData.write('isLoged', true);
                                  } else {
                                    print('Not Completed');
                                  }
                                  //_submit();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xffe8e6e6),
        width: double.infinity,
        height: 150,
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'ALREADY HAVE AN ACCOUNT?',
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0, bottom: 0.0)),
            Container(
              height: 50,
              width: 330,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 0.6,
                    offset: Offset(2.4, 3.5),
                  )
                ],
              ),
              child: FlatButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor)),
                color: Theme.of(context).accentColor,
                child: Text(
                  'LOGIN NOW',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                phoneNo: phoneNo,
                                sms: sms,
                                verificationId: verificationId,
                              )));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: 0.0,
              ),
              child: Container(
                width: 320,
                child: Text(
                  'Don`t worry your data will not be shared with anyone.Please read our Terms of Service and Privacy Policy',
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }
}
