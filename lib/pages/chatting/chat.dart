import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/pages/chatting/chat/shareImage.dart';
import 'package:guftagu/pages/chatting/chat/sharevideo.dart';

import '../../constants/theme.dart';
import 'chat/chatting.dart';
import 'chat/shareAudio.dart';
enum SelectedPage {
  videos,
  images,
  chats,
  audio
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
    } else if(selectedPage==SelectedPage.images){
      return ShareImage(widget.receiverId, FirebaseAuth.instance.currentUser!.uid);
    }
    else if (selectedPage == SelectedPage.audio) {
      return ShareAudio(
          widget.receiverId, FirebaseAuth.instance.currentUser!.uid);
    }
    else {
      return ShareVideo(widget.receiverId, FirebaseAuth.instance.currentUser!.uid);
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
                else if (value == 'videos') {
                    selectedPage = SelectedPage.videos;
                  }
                  else if (value == 'audio') {
                    selectedPage = SelectedPage.audio;
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
               PopupMenuItem<String>(
                  value: 'audio',
                  child: Container(
                      color: selectedPage == SelectedPage.audio
                          ? color.yellow
                          : Colors.transparent,
                      child: Text('Audio')),
                ),
              PopupMenuItem<String>(
                  value: 'videos',
                  child: Container(
                      color: selectedPage == SelectedPage.videos
                          ? color.yellow
                          : Colors.transparent,
                      child: Text('Videos')),
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
