import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/splash_screen.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdTime', descending: true)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Message found.'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final List<QueryDocumentSnapshot<Map<String, dynamic>>>
              loadedMessages = snapshot.data!.docs;
          User? user = FirebaseAuth.instance.currentUser;

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {

              final chatMessage = loadedMessages[index].data();
              final nextMessage =
                  index + 1 < loadedMessages.length
                      ? loadedMessages[index + 1].data()
                      : null;
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextMessage != null ? nextMessage['userId'] : null;
              final bool nextUserIsSame =
                  currentMessageUserId == nextMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: user!.uid == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['imgUrl'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: user!.uid == currentMessageUserId,
                );
              }
            },
          );
        } else {
          return const Text('Snapshot does not have data');
        }
      },
    );
  }
}
