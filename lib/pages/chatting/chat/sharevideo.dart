import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/constants/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'helping_func.dart';

class ShareVideo extends StatefulWidget {
  String receiveId;
  String sendId;

  ShareVideo(this.receiveId, this.sendId);

  @override
  State<ShareVideo> createState() => _ChattingState();
}

class _ChattingState extends State<ShareVideo> {
  Rang color = Rang();
  ScrollController _scrollController = ScrollController();
  
  File? videoFile;
  String? videoUrl;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> uploadUrl() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        videoFile = File(pickedFile.path);
      });
    }

    String videoUrl = await uploadVideo(videoFile) as String;
    print(videoUrl);
    sendVideo(widget.sendId, widget.receiveId, videoUrl);
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
            stream: dataStream(widget.sendId, widget.receiveId, 'sharevideo'),
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
                    final url = message['videourl'] as String;

                    //
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
                    final videoPlayerController =VideoPlayerController.networkUrl(Uri.parse(url));
                    final chewieController = ChewieController(
                      videoPlayerController: videoPlayerController,
                      autoInitialize: true,
                      looping: false,
                      showControls: true,
                      // You can customize other Chewie options here
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chewie(controller: chewieController),
       
                                )
                                );
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
                                                                    maxHeight:
                                    MediaQuery.of(context).size.width * 0.70,
                              ),
                              padding: EdgeInsets.all(8.0),
                              
                              decoration: BoxDecoration(
                              
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Chewie(
                                controller: chewieController,
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
