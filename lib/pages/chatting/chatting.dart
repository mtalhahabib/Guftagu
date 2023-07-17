import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/constants/theme.dart';

class Chatting extends StatefulWidget {
  String receiveId;
  String sendId;

  Chatting(this.receiveId, this.sendId);

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  Rang color = Rang();
  TextEditingController _chat = TextEditingController();
  ScrollController _scrollController = ScrollController();

  bool bool_chat = false;
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
            stream: FirebaseFirestore.instance
                .collection('chats')
                .where('senderId', isEqualTo: widget.sendId)
                .where('receiverId', isEqualTo: widget.receiveId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
                print(snapshot.error);
              }
              if (snapshot.hasData) {
                final messages = snapshot.data!.docs;
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final senderId = message['senderId'] as String;
                    final receiverId = message['receiverId'] as String;
                    final messageText = message['message'] as String;

                    // Determine whether the message is sent by the sender or receiver
                    final isSenderMessage = senderId == currentUserId;
                    print(senderId);
                    print(receiverId);
                    // Determine the alignment of the chat message based on the sender/receiver
                    final alignment = isSenderMessage
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end;

                    // Determine the background color of the chat message based on the sender/receiver
                    final backgroundColor =
                        isSenderMessage ? color.receiverText : color.senderText;
                    // Display the chat message with appropriate alignment and background color
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                            child: Text(
                              messageText,
                              style: TextStyle(
                                color: color.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                        ],
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
              height: 64,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(164),
                  border: Border.all(color: color.scrollBar, width: 1)),
              child: Row(children: [
                IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(
                      backgroundColor: color.yellow,
                      child: Icon(
                        Icons.add,
                        color: color.black,
                      ),
                    )),
                Expanded(
                  child: TextField(
                    maxLines: null, // Allow multiple lines of text
                    keyboardType:
                        TextInputType.multiline, // Enable multiline keyboard
                    textInputAction: TextInputAction.newline,
                    controller: _chat,
                    onChanged: ((value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          bool_chat = true;
                        });
                      } else {
                        setState(() {
                          bool_chat = false;
                        });
                      }
                    }),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type message',
                        hintStyle: TextStyle(
                          color: color.description,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendMessage(widget.sendId, widget.receiveId, _chat.text);

                      _chat.clear();
                    },
                    icon: CircleAvatar(
                      backgroundColor: color.yellow,
                      child: Icon(
                        bool_chat ? Icons.send : (Icons.mic),
                        color: color.black,
                      ),
                    ))
              ]),
            ),
          )
        ],
      ),
    );
  }
}

void sendMessage(String? senderId, String? receiverId, String? message) {
  print(senderId);
  print(receiverId);
  print(message);
  // Create a reference to the "chats" collection
  CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  // Create a new document with an auto-generated ID
  DocumentReference newMessageRef = chatsCollection.doc();

  // Create a map representing the message data
  Map<String, dynamic> messageData = {
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'timestamp': DateTime.now(),
  };

  // Write the message document to Firestore
  newMessageRef.set(messageData).then((value) {
    // Message sent successfully
    print('Message sent');
  }).catchError((error) {
    // Error occurred while sending the message
    print('Error sending message: $error');
  });
}
