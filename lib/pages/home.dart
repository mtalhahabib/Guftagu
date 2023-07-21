import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guftagu/pages/splash.dart';
import 'package:guftagu/pages/widgets/widget_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  SystemUiOverlayStyle getSystemUiOverlayStyle() {
    return SystemUiOverlayStyle(
      statusBarColor: color.black,
    );
  }

  Future<DocumentSnapshot> fetchUserProfile(user) async {
    if (user != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
    }
    throw Exception('User is null');
  }

  Rang color = Rang();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(getSystemUiOverlayStyle());
    return FutureBuilder<DocumentSnapshot>(
        future: fetchUserProfile(widget.user),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: color.yellow,
            );
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            String photoURL = data['photoURL'];
            String firstName = data['firstName'];
            String lastName = data['lastName'];
            return WillPopScope(
              onWillPop: () async {
                SystemNavigator.pop();
                return true;
              },
              child: Scaffold(
                backgroundColor: color.black,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 150,
                  titleSpacing: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        onPressed: () {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(1000, 123, 0, 0),
                            items: [
                              PopupMenuItem(
                                value: 'signOut',
                                child: Text('Sign Out'),
                              ),
                            ],
                          ).then((value) async {
                            if (value == 'signOut') {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('isLoggedIn', false);
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SplashScreen(),
                                ),
                              );
                            }
                          });
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: color.white,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                  title: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 100,
                          width: 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('   Welcome, ',
                                style: TextStyle(
                                    color: color.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Inter")),
                            Text(firstName!,
                                style: TextStyle(
                                    color: color.yellow,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: color.black,
                ),
                body: list.elementAt(selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.chat_bubble,
                        ),
                        label: 'Chats'),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.call_sharp,
                        ),
                        label: 'Calls'),
                    BottomNavigationBarItem(
                      icon: CircleAvatar(
                          backgroundColor: color.yellow,
                          child: Icon(
                            Icons.add,
                            color: color.black,
                            weight: 30.0,
                            size: 30.0,
                          )),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.screen_share_outlined,
                        ),
                        label: 'Share Screen'),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.info,
                        ),
                        label: 'Profile')
                  ],
                  type: BottomNavigationBarType.fixed,
                  unselectedFontSize: 10,
                  selectedFontSize: 10,
                  showUnselectedLabels: true,
                  showSelectedLabels: true,
                  currentIndex: selectedIndex,
                  unselectedItemColor: color.description,
                  selectedItemColor: color.black,
                  onTap: _onItemTapped,
                ),
              ),
            );
          }
          return Text('Nothing to Show');
        });
  }
}
