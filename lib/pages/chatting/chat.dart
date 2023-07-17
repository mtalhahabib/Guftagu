import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/theme.dart';
import 'chatting.dart';

class ChatScreen extends StatefulWidget {
  String receiverId;
  String name;
  String photo;
  ChatScreen(this.receiverId, this.name, this.photo);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Rang color = Rang();
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String senderId = currentUser!.uid;
    print(senderId);
    print(widget.receiverId);
    return Scaffold(
        backgroundColor: color.black,
        appBar: AppBar(
          toolbarHeight: 100,
          titleSpacing: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_sharp,
                color: color.white,
              ),
            ),
          ],
          title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.photo,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        style: TextStyle(
                            color: color.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter')),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Online',
                        style: TextStyle(
                            color: color.description,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                )
              ],
            ),
          ),
          backgroundColor: color.black,
        ),
        body: Chatting(widget.receiverId, senderId));
  }
}
