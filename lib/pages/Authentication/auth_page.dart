import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guftagu/pages/Authentication/verification.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../constants/theme.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController phoneController = TextEditingController(text: '+92');
  Rang color = Rang();
  // FirebaseAuth auth=FirebaseAuth.instance;

  String countryCode = '+92';
  bool loading = false;
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 60,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Column(children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: color.yellow,
                ),
                child: Image.asset('assets/logo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Assalam o Alaikum!!",
                style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: color.yellow),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              Text(
                "Welcome to GUFTAGU .......",
                style: TextStyle(
                    color: color.yellow,
                    fontFamily: "Inter",
                    fontSize: 27,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900),
              ),
            ]),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone no ",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: color.yellow),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              color: color.yellow.withOpacity(0.5),
                            ),
                            prefixIconColor: color.yellow,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.yellow,
                              ),
                            ),
                          ),
                        ))
                  ]),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: TextButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (PhoneAuthCredential credential) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    print("Error is given below ${e}");
                  },       
                  codeSent: (String verificationId, int? resendToken) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationScreen(verificationId: verificationId,)));
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.yellow,
                    border: Border.all(color: color.yellow, width: 0.76),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: loading
                        ? CircularProgressIndicator(
                            color: color.white,
                          )
                        : Text(
                            'Register/Login',
                            style: TextStyle(
                                color: color.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
