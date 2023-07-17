import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/pages/chatting/chat.dart';

import '../../constants/theme.dart';

class Messages extends StatelessWidget {
  Messages({super.key});

  Rang color = Rang();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topCenter,
            height: 3,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: color.scrollBar),
          ),
          Expanded(
              child: FutureBuilder<List<User>>(
            future:
                fetchUsers(), // Fetch user data from Firestore or user management system
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data!;

                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (BuildContext, int index) {
                      User user = users[index];
                      return Column(
                        children: [
                          ListTile(
                              onTap: () {
                                Navigator.push(BuildContext,
                                    MaterialPageRoute(builder: (context) {
                                  return ChatScreen(user.receiverId,
                                      user.firstName!, user.photoURL!);
                                }));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user.photoURL!,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    user.firstName!,
                                    style: TextStyle(
                                        color: color.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter'),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text('12:00 PM',
                                      style: TextStyle(
                                          color: color.description,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'As Salaam',
                                    style: TextStyle(
                                        color: color.description,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(
                                    Icons.done_all_sharp,
                                    size: 15,
                                  )
                                ],
                              )),
                          Container(
                            alignment: Alignment.topCenter,
                            height: 0,
                            width: 335,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: color.scrollBar, width: 0.18),
                                color: color.scrollBar),
                          ),
                        ],
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return CircularProgressIndicator();
            },
          )),
        ],
      ),
    );
  }
}

Future<List<User>> fetchUsers() async {
  try {
    // Fetch user data from Firestore or user management system
    // Replace this with your actual implementation
    // Example: Query Firestore collection and map the documents to User objects
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<User> users = [];
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      String receiverId = documentSnapshot.id;
      
      User user = User(
        receiverId: receiverId,
        photoURL: data['photoURL'],
        firstName: data['firstName'],
        lastName: data['lastName'],

        // Add more user properties as needed
      );
      users.add(user);
    }
    return users;
  } catch (e) {
    print('Error fetching users: $e');
    return [];
  }
}

class User {
  final String receiverId;
  final String photoURL;
  final String firstName;
  final String lastName;

  User({
    required this.receiverId,
    required this.photoURL,
    required this.firstName,
    required this.lastName,
  });
}
