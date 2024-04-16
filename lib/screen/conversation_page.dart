import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';


class ChatPage extends StatefulWidget {
  final String receiverUserId;
  final String receiverUserEmail;

  const ChatPage({
    Key? key,
    required this.receiverUserId,
    required this.receiverUserEmail,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final record = AudioRecorder();
  late AudioPlayer audioPlayer;
  String path = '';
  String url = '';
  bool isRecording = false;
  bool isPlaying = false;
  AudioPlayer newAudioPlayer = AudioPlayer();

  startRecord() async {
    final location = await getApplicationDocumentsDirectory();
    String name = Uuid().v1();
    if (await record.hasPermission()) {
      setState(() {
        isRecording = true;
      });
      await record.start(RecordConfig(), path: '${location.path}/$name.m4a');
    }
    print("Recording Started");
  }

  stopRecord() async {
    String? finalPath = await record.stop();
    setState(() {
      path = finalPath!;
      isRecording = false;
    });
    print("Recording Stopped");
    upload(); // Await upload function call
  }

  upload() async {
    String name = basename(path);
    final ref = FirebaseStorage.instance.ref('Voice'+name);
    await ref.putFile(File(path!));
    String downloadUrl = await ref.getDownloadURL();
    setState(() {
      url = downloadUrl;
    });
    print("Uploaded");
  }

  play(url) async {
    await newAudioPlayer.play(url);
    setState(() {
      isPlaying = true;
    });
    print("Audio Playing!!");
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.SendMessage(widget.receiverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  void sendVoice() async {
    if (url.startsWith('https://firebasestorage.googleapis.com/')) {
      await _chatService.SendMessage(widget.receiverUserId, url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: () {
              // Add your call functionality here
            },
            icon: Icon(Icons.call), // Use the call icon
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'images/bk.png',
            fit: BoxFit.cover,
            width: double.infinity, 
            height: double.infinity,
          ),
      Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs.reversed.toList();

        return ListView.builder(
          reverse: false, // Display the list in reverse order
          itemCount: messages.length,
          itemBuilder: (context, index) {
            if (messages[index]['message'].startsWith('https://firebasestorage.googleapis.com/')) {
              return VoiceMessageBubble(
                messageUrl: messages[index]['message'],
                isSent: messages[index]['senderId'] == _firebaseAuth.currentUser!.uid,
                time: _formatTimestamp(messages[index]['timestamp']),
              );
            } else {
              return TextMessageBubble(
                message: messages[index]['message'],
                isSent: messages[index]['senderId'] == _firebaseAuth.currentUser!.uid,
                time: _formatTimestamp(messages[index]['timestamp']),
              );
            }
          },
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = '${dateTime.hour}:${dateTime.minute}:${dateTime.second}'; // Format hours, minutes, and seconds
    return formattedTime;
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: startRecord,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              stopRecord();
              sendVoice();
            },
          ),
        ],
      ),
    );
  }
}

class VoiceMessageBubble extends StatelessWidget {
  final String messageUrl;
  final bool isSent;
  final String time;

  const VoiceMessageBubble({
    Key? key,
    required this.messageUrl,
    required this.isSent,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSent ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    final Player = AudioPlayer();
                    Player.play(UrlSource(messageUrl));
                  },
                ),
                SizedBox(width: 8),
                Text(
                  '',
                  style: TextStyle(color: isSent ? Colors.white : Colors.black),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class TextMessageBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final String time;

  const TextMessageBubble({
    Key? key,
    required this.message,
    required this.isSent,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSent ? Color(0xFF8E4DB2) : Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(color: isSent ? Colors.white : Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(fontSize: 12, color: isSent ? Colors.white : Colors.black),
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                // Function to be executed when the button is pressed
                _onButtonPressed(context);
              }, child: Text('change to voice'),
            )
          ],
        ),
      ),
    );
  }
}
  void _onButtonPressed(BuildContext context) {
    // Add your custom function here to be executed when the button is pressed
    print("Button pressed!");
    // You can add any other functionality you want here
  }
