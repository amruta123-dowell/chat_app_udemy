import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/new_message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    setupPushNotifications();
    super.initState();
  }

  setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

//To send th message at a a time for all registered device
    await fcm.subscribeToTopic("chat_notifications");

    // await fcm
    //     .getToken(); //You could send this token(via firebase sdk or http)to the backend
    print("push notification token ----------------> ${await fcm.getToken()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat screen"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(child: ChatMessageWidget()),
            NewMessageWidget(),
          ],
        ));
  }
}
