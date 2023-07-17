import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/theme.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  Rang color = Rang();
   


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Container(
            color: color.black,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 400,
                      width: 400,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          height: 3,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.yellow),
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    color: color.yellow,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Text(
                            'Stay Connected with GUFTAGU',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: color.black,
                                fontSize: 36,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            children: [
                              Icon(Icons.verified, color: Colors.deepPurple),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Secure, Private messaging",
                                style: TextStyle(
                                    color: color.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Container(
                              height: 64,
                              width: 314,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: color.white,
                              ),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                      color: color.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
