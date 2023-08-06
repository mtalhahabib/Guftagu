import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/pages/chatting/shareImage.dart';

import '../../constants/theme.dart';
import 'chatting.dart';
enum SelectedPage {
  images,
  chats,
}
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
  
 SelectedPage selectedPage = SelectedPage.chats;

  Widget getBody() {
    if (selectedPage == SelectedPage.chats) {
      return Chatting(widget.receiverId, FirebaseAuth.instance.currentUser!.uid);
    } else {
      return ShareImage(widget.receiverId, FirebaseAuth.instance.currentUser!.uid);
    }
  }
  Rang color = Rang();
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: color.black,
        appBar: AppBar(
          toolbarHeight: 100,
          titleSpacing: 0,
          actions: [
PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'chats') {
                  selectedPage = SelectedPage.chats;
                } else if (value == 'images') {
                  selectedPage = SelectedPage.images;
                }
              });
            },
                         itemBuilder: (context) => [
               PopupMenuItem<String>(
                  value: 'chats',
                  child: Container(color: selectedPage == SelectedPage.chats
                          ? color.yellow
                          : Colors.transparent,

                  child: Text('Chatting')),
                ),
              PopupMenuItem<String>(
                value: 'images',
                child: Container(
                      color: selectedPage == SelectedPage.images
                          ? color.yellow
                          : Colors.transparent,
                      child: Text('Images')),
                
              ),
             
            ],
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
        body: getBody());
  }
}
