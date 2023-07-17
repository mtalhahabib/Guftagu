import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/pages/home.dart';
import 'package:guftagu/pages/profile.dart';

import '../../constants/theme.dart';

class VerificationScreen extends StatefulWidget {
  String verificationId;
  VerificationScreen({required this.verificationId});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController smsController = TextEditingController();
  Rang color = Rang();

  void redirectProfileScreen(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userProfile.exists) {
        // User profile exists, redirect to profile screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: currentUser),
          ),
        );
      } else {
        // User profile doesn't exist, redirect to profile creation screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: currentUser),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        elevation: 0,
        backgroundColor: color.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: smsController,
              decoration: InputDecoration(
                hintText: 'Enter 6 Digits OTP',
                suffixIcon: IconButton(
                  onPressed: () {
                    try {
                      final credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: smsController.text);
                      FirebaseAuth.instance.signInWithCredential(credential);

                      redirectProfileScreen(context);
                    } on FirebaseAuthException catch (e) {
                      // if you want to show the message in the app, use
                      // return  e.message and show it in a widget or snack bar

                      print(e);
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
