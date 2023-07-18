import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                return Text(
                  loadedMessage[index].data()['text'],
                  style: const TextStyle(color: Colors.amber),
                );
              });
        });
  }
}
