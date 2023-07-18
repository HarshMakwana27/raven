import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  const MessageField({super.key});

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final _messageController = TextEditingController();

  void _onSend() async {
    final enteredMessage = _messageController.text;

    _messageController.clear();
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'userName': userData.data()!['username'],
      'userImage': userData.data()!['imageURL'],
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(hintText: "Message"),
                controller: _messageController,
                enableSuggestions: true,
                autocorrect: true,
                onChanged: (value) => setState(() {}),
              ),
            ),
            _messageController.text.isNotEmpty
                ? IconButton(
                    onPressed: _onSend,
                    icon: const Icon(Icons.send_rounded),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
