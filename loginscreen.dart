import 'dart:convert';
import 'package:egarage/apiintegration/responsepodo.dart';
import 'package:egarage/dashboarsd.dart';
import 'package:egarage/methods/common%20method.dart';
import 'package:egarage/screens/registerscreen.dart';
import 'package:egarage/screens/verifyscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget {
  final String phoneNo;
  final String sms;
  final String verificationId;

  LoginScreen({
    @required this.phoneNo,
    @required this.sms,
    @required this.verificationId,
  });

  static String routName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String lCompanyId;
  String lEmployeeId;
  String lEmployeephonenumber;
  String lEmployeeName;
  String lWorkshopName;

  final userData = GetStorage();

  final _formKey = GlobalKey<FormState>();
  bool _isShowPassword = true;

  //final TextEditingController deviceidController=TextEditingController();

  void _openPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyScreen(
                  phoneNo: widget.phoneNo,
                  sms: widget.sms,
                  verificationId: widget.verificationId,
                  verifyCompnyid: lCompanyId,
                  verifyEmployeeid: lEmployeeId,
                )));
  }

  // ignore: missing_return
  Future<bool> get smsCodeSent async {
    _openPage();
  }

  Future<void> _submit() async {
    // ignore: unused_local_variable
    var verifiID = widget.verificationId;

    print(widget.verificationId);
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
      smsCodeSent.then((value) {
        print('Signed In');
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String veriId) {
      verifiID = veriId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${this.widget.phoneNo}",
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCode,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  Future<Loginfo> loginUser() async {
    var Url = 'https://www.egarage.in/api/login';
    var phoneNumber = PhoneNumber.text;
    var passWord = Password.text;

    var headers = {
      'token': 'b2905de7-0df5-44ee-f760-5a78be12e9d3',
      'key': 'ccdb973a-7b1e-4f52-e3b7-4e9e59dfac67',
      'application_id': '1',
    };

    final body = {
      'device_id': getDeviceDetails().toString(),
      'phone_number': phoneNumber,
      'password': passWord,
      'login_type': "flutter",
    };

    final response = await http.post(Url, headers: headers, body: body);
    print(response.body);
    final log = response.body;
    var datas = Loginfo.fromJson(json.decode('$log'));

    userData.write('compnyId', datas.result.companyId.toString());
    userData.write('employeeId', datas.result.employeeId.toString());
    userData.write('employeeName', datas.result.employeeName.toString());
    userData.write(
        'employeePhoneno', datas.result.employeePhoneNumber.toString());
    userData.write('workshopName', datas.result.workshopName.toString());
    if (response.statusCode == 200) {
      print("url successful " + response.body);

      lCompanyId = datas.result.companyId.toString();
      lEmployeeId = datas.result.employeeId.toString();
      lEmployeeName = datas.result.employeeName.toString();
      lEmployeephonenumber = datas.result.employeePhoneNumber.toString();
      lWorkshopName = datas.result.workshopName.toString();

      if (datas.result.verified == '0') {
        print(response.body);
        _submit();
      } else {
        // ignore: unused_element
        addBoolvalue() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isAlreadyMember", true);
        }

        return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      print(response.body);
      print(datas.msg);
      throw Exception(datas.msg);
    }
  }

  TextEditingController PhoneNumber = TextEditingController();
  TextEditingController Password = TextEditingController();

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
              SizedBox(
                height: 0.0,
              ),
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
                  height: 350,
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
                                  Icons.flag,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: TextField(
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    labelText: '+91(INDIA)',
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
                                  keyboardType: TextInputType.text,
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
                              borderRadius: BorderRadius.circular(10.0),
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
                                'LOGIN',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  loginUser();
                                  userData.write('isLoged', true);
                                } else {
                                  Get.snackbar(
                                      'Error', "Please Enter a valid Value",
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                            ),
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
                'START WITH YOUR NEW ACCOUNT TODAY',
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
                  ),
                ],
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor)),
                color: Theme.of(context).accentColor,
                child: Text(
                  'CREATE NEW ACCOUNT',
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
                          builder: (context) => RegisterScreen()));
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
