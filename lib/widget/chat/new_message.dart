import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = TextEditingController();
  String _enteredMessage = '';

  // Send Function
  sendMessage() async {
    FocusScope.of(context).unfocus();
    // send a message
    final User? user = FirebaseAuth.instance.currentUser;

    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdTime': Timestamp.now(),
      'userId': user.uid,
      'username': userdata.data()!['username'],
      'imgUrl': userdata.data()!['imgUrl'],
    });
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  /// What's the different between add() && set() ?

  /// add(): auto generate doc with unique id and store date inside the doc //  .collection(' ').add(Map());
  /// set(): need to create specific doc in code //  .collection(' ').doc(' ').set(Map());
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      padding: const EdgeInsets.only(left: 12, right: 5, top: 6, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const ValueKey('message'),
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 13,
              ),
              controller: _controller,
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val.trim();
                });
                print(_enteredMessage);
                print(_enteredMessage.trim().length);
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                hintText: 'Enter Your message...',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(30)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(30)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(30)),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            color: _enteredMessage.trim().isEmpty
                ? Colors.black
                : Theme.of(context).colorScheme.primary,
            onPressed: _enteredMessage.trim().isEmpty ? null : sendMessage,
            icon: const Icon(
              Icons.send_rounded,
              size: 35,
            ),
          ),
          //const SizedBox(width: 5),
        ],
      ),
    );
  }
}
