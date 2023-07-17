import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guftagu/pages/home.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/theme.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  Rang color = Rang();
  File? _imageFile;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future uploadInfo() async {
    
    try {
      if (_imageFile != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profilePictures/${widget.user?.uid}');
        
        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        await uploadTask.whenComplete(() => print('Image uploaded'));
        String downloadURL = await storageReference.getDownloadURL();
        
        // Save user profile data to Firestore including the image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user?.uid)
            .set({
          'firstName': _firstname.text, // Replace with user's display name
          'lastName': _lastname.text, // Store email in profile if needed
          'photoURL': downloadURL, // Store the image URL in profile
          // Add other profile details as needed
        });
        
        redirectHomeScreen();
      }
    } catch (e) {
      print(e);
    }
  }

  void redirectHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Complete Profile',
              style: TextStyle(color: Colors.black)),
          elevation: 0,
          backgroundColor: color.yellow,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _imageFile == null
                          ? Image.asset(
                              'assets/dummy.png',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: color.yellow,
                      ),
                      child: TextButton(
                        clipBehavior: Clip.antiAlias,
                        onPressed: _pickImage,
                        child: Text(
                          'Upload  Picture',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _firstname,
                        cursorColor: color.yellow,
                        decoration: InputDecoration(
                            hintText: 'Enter First Name',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color.yellow),
                            ), // Specify your desired color here
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: color
                                      .yellow), // Specify your desired color here
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _lastname,
                        cursorColor: color.yellow,
                        decoration: InputDecoration(
                            hintText: 'Enter Last Name',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color.yellow),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: color
                                      .yellow), // Specify your desired color here
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: color.yellow,
                      ),
                      child: TextButton(
                        onPressed: () {
                          uploadInfo();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
