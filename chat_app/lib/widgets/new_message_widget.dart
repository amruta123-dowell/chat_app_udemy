import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  const NewMessageWidget({super.key});

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.clear();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMsg = _msgController.text;
    if (enteredMsg.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    _msgController.clear();

    final sendMsgToFirestore =
        await FirebaseFirestore.instance.collection("chat").add({
      "userName": userData.data()!["username"],
      "userImage": userData.data()!["image_url"],
      "text": enteredMsg,
      "createdAt": Timestamp.now(),
      "userId": user.uid
    });

    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _msgController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Send a message"),
            )),
            IconButton(
                onPressed: _submitMessage,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ],
        ));
  }
}
