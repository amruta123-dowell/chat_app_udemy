import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No chat is found...."),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong....."),
            );
          }
          final chatData = snapshot.data!.docs;
          return ListView.builder(
              itemCount: chatData.length,
              reverse: true,
              itemBuilder: (context, index) {
                final chatMessage = chatData[index].data();
                final nextChatMsg = index + 1 < chatData.length
                    ? chatData[index + 1].data()
                    : null;
                final currentMsgUserId = chatMessage["userId"];
                final nextMsgUserId =
                    nextChatMsg != null ? nextChatMsg["userId"] : null;
                final nextUserIsSame = currentMsgUserId == nextMsgUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage["text"],
                      isMe: authenticatedUser!.uid == currentMsgUserId);
                }
                return MessageBubble.first(
                    userImage: chatMessage["userImage"],
                    username: chatMessage["userName"],
                    message: chatMessage["text"],
                    isMe: authenticatedUser!.uid == currentMsgUserId);
              });
        });
  }
}
