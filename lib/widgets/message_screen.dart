import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raven/widgets/chat_bubble.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'say Hi',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final loadedMessage = chatSnapshots.data!.docs;
          return ListView.builder(
              itemCount: loadedMessage.length,
              padding: const EdgeInsets.all(10),
              reverse: true,
              itemBuilder: (ctx, index) {
                final currentMessage = loadedMessage[index].data()['text'];
                final nextMessage = index + 1 < loadedMessage.length
                    ? loadedMessage[index + 1].data()['text']
                    : null;

                final currentUser = loadedMessage[index].data()['userID'];

                final NextUser = nextMessage != null
                    ? loadedMessage[index].data()['userID']
                    : null;

                final nextUserisSame = currentUser == NextUser;

                if (nextUserisSame) {
                  return MessageBubble.next(
                      message: currentMessage,
                      isMe: FirebaseAuth.instance.currentUser == currentUser);
                } else {
                  return MessageBubble.first(
                      userImage: loadedMessage[index].data()['userImage'],
                      username: currentUser,
                      message: currentMessage,
                      isMe: FirebaseAuth.instance.currentUser == currentUser);
                }
              });
        });
  }
}
