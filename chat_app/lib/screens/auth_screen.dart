import 'dart:developer';
import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebase = FirebaseAuth.instance;
  bool _isLogIn = true;
  final _formKey = GlobalKey<FormState>();
  String? _enteredEmail = '';
  String? _enteredPass = '';
  File? _selectedImage;
  bool _isAuthenticating = false;
  String _enteredUsername = '';

  void onSubmit() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid || (!_isLogIn && _selectedImage == null)) {
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isAuthenticating = true;
        });
        if (_isLogIn) {
          final userCredential = await _firebase.signInWithEmailAndPassword(
              email: _enteredEmail!, password: _enteredPass!);
        } else {
          final userCredential = await _firebase.createUserWithEmailAndPassword(
              email: _enteredEmail!, password: _enteredPass!);

          final userStoreImg = FirebaseStorage.instance
              .ref()
              .child("User_profile_images")
              .child("${userCredential.user!.uid}.jpg");

          //upload to firebase
          await userStoreImg.putFile(_selectedImage!);
          final imageUrl = await userStoreImg.getDownloadURL();
          log("firebase download link --------------------------> $imageUrl");

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "username": _enteredUsername,
            "email": _enteredEmail,
            "image_url": imageUrl
          });
        }
      } catch (error) {
        log(error.toString());
        print(error.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void setFireStore() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogIn)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                const InputDecoration(labelText: "Email ID"),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.contains('@') == false) {
                                return "Incorrect email";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredEmail = value;
                            },
                          ),
                          if (!_isLogIn)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Username"),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return "Please enter at least 4";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            onSaved: (value) {
                              _enteredPass = value;
                            },
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Incorrect password";
                              } else {
                                return null;
                              }
                            },
                          ),
                          if (_isAuthenticating)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(),
                            ),
                          if (!_isAuthenticating) ...[
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                onPressed: onSubmit,
                                child: Text(_isLogIn ? "Sign in" : "Sign up")),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogIn = !_isLogIn;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_isLogIn
                                    ? "Already have an account"
                                    : "Create new account"))
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
