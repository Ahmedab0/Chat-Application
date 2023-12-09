import 'package:flutter/material.dart';
import 'package:chats/widget/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widget/chat/chat_messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          TextButton.icon(
              onPressed: () async =>
                await FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.exit_to_app,color: Colors.white,),
              label: const Text('Exit',style: TextStyle(color: Colors.white),))
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Column(
        children: [
          // section chats
          Expanded(
            child: Messages(),
          ),
          // Text Input Field Section
          NewMessage(),
        ],
      )
    );
  }
}
