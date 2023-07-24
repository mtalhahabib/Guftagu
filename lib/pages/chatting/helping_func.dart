

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';



Future<void> sendMessage(String? senderId, String? receiverId, String? message,

  
 
) async {
  print(senderId);
  print(receiverId);
  print(message);
  // Create a reference to the "chats" collection
  CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  // Create a new document with an auto-generated ID
  DocumentReference newMessageRef = chatsCollection.doc();
  String? mediaUrl;

  

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






Stream<QuerySnapshot<Object?>>? combinedStream(sendId, receiveId) {
  final query1 = FirebaseFirestore.instance
      .collection('chats')
      .where('senderId', isEqualTo: sendId)
      .where('receiverId', isEqualTo: receiveId)
      .orderBy('timestamp', descending: true)
      .snapshots();

// Query 2: where senderId = widget.receiveId and receiverId = widget.sendId
  final query2 = FirebaseFirestore.instance
      .collection('chats')
      .where('senderId', isEqualTo: receiveId)
      .where('receiverId', isEqualTo: sendId)
      .orderBy('timestamp', descending: true)
      .snapshots();

// Combine the results of both queries
  Stream<QuerySnapshot<Object?>>? combinedStream =
      Rx.combineLatest2(query1, query2, (query1Snapshot, query2Snapshot) {
    // Process and merge the snapshots from both queries
    // For example, you can merge the documents and sort them based on the timestamp
    final mergedDocuments = [...query1Snapshot.docs, ...query2Snapshot.docs];
    mergedDocuments.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
// This line of code creates a new list called mergedDocuments by merging the 
// two lists query1Snapshot.docs and query2Snapshot.docs together. 
// The spread operator ... is used before each list, which means 
// that all the elements from both lists will be included in the new list mergedDocuments. 
// The resulting mergedDocuments list will contain all the documents from query1Snapshot.docs 
// followed by all the documents from query2Snapshot.docs.
    return QuerySnapshot<Object?>(
      docs: mergedDocuments,
      size: mergedDocuments.length,
      empty: mergedDocuments.isEmpty,
      metadata: query1Snapshot.metadata,
    );
  }).asBroadcastStream();

// Convert the stream to nullable type
  Stream<QuerySnapshot<Object?>>? nullableStream = combinedStream;
  return combinedStream;
}

class QuerySnapshot<T> {
  final List<T> docs;
  final int size;
  final bool empty;
  final dynamic metadata;

  QuerySnapshot({
    required this.docs,
    required this.size,
    required this.empty,
    required this.metadata,
  });
}
