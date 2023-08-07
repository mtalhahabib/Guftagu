import 'package:audioplayers/audioplayers.dart';

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/constants/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'helping_func.dart';

class ShareAudio extends StatefulWidget {
  String receiveId;
  String sendId;

  ShareAudio(this.receiveId, this.sendId);

  @override
  State<ShareAudio> createState() => _ChattingState();
}

class _ChattingState extends State<ShareAudio> {
  Rang color = Rang();
  ScrollController _scrollController = ScrollController();

  String? audioUrl;
  File? audioFile;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void audioDialog(BuildContext context, url,name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Audio Dialog'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Now playing: ${name}'),
              SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(color.yellow),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  audioPlayer.stop();
                },
                child: Text('Close Audio'),
              ),
            ],
          ),
        );
      },
    );

    audioPlayer.play(UrlSource(url));
  }

  Future<void> uploadUrl() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    PlatformFile file = result!.files.first;
    if (file != null) {
      setState(() {
        audioFile = File(file.path ?? '');
      });
    }

    String audioUrl = await uploadAudio(audioFile) as String;
    print(audioUrl);
    sendAudio(widget.sendId, widget.receiveId, audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    return Container(
      decoration: BoxDecoration(
          color: color.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: dataStream(widget.sendId, widget.receiveId, 'shareAudio'),
            // FirebaseFirestore.instance
            //     .collection('chats')
            //     .where('senderId', isEqualTo: widget.sendId)
            //     .where('receiverId', isEqualTo: widget.receiveId)
            //     .orderBy('timestamp', descending: true)
            //     .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
                print(snapshot.error);
              }
              if (snapshot.hasData) {
                final messages = snapshot.data!.docs;
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final senderId = message['senderId'] as String;
                    final receiverId = message['receiverId'] as String;
                    final url = message['audiourl'] as String;

                    String standardTime = time(message['timestamp']);
                    //e message is sent by the sender or receiver
                    final isSenderMessage = senderId == currentUserId;

                    // Determine the alignment of the chat message based on the sender/receiver
                    final alignment = isSenderMessage
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end;

                    // Determine the background color of the chat message based on the sender/receiver
                    final backgroundColor =
                        isSenderMessage ? color.receiverText : color.senderText;
                    // Display the chat message with appropriate alignment and background color

                    return GestureDetector(
                      onTap: () {
                        // audioPlayer.play(UrlSource(url));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: alignment,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.70,
                              ),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  IconButton(onPressed: (){
                                    audioDialog(context, url,standardTime);
                                  }, icon: Icon(Icons.play_circle_outline_outlined)),
                                  Text(
                                    standardTime,
                                    style: TextStyle(
                                      color: color.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color.scrollBar, width: 1)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                    alignment: Alignment.center,
                    onPressed: () {
                      uploadUrl();
                    },
                    icon: CircleAvatar(
                      backgroundColor: color.yellow,
                      child: Icon(
                        Icons.upload,
                        color: color.black,
                      ),
                    )),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
