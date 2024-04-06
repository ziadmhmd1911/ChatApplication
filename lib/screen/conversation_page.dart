import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/my_drawer.dart';

class ConversationPage extends StatefulWidget {
  final int chatIndex;

  const ConversationPage({Key? key, required this.chatIndex}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    // Replace these with actual receiver data
    String receiverName = 'Jane Doe';
    String receiverProfilePictureUrl = 'https://example.com/receiver_profile.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(receiverProfilePictureUrl),
            ),
            SizedBox(width: 10),
            Text(receiverName),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Implement call functionality
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(
                  message: _messages[index],
                  isSent: index.isEven,
                  time: '10:00 AM', // Replace with actual message timestamp
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(context),
          ),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmitted(_textController.text);
              },
            ),
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: _startRecording, // Call method to start recording voice notes
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, text); // Insert message at the beginning of the list
    });
  }

  void _startRecording() {
    // Implement method to start recording voice notes
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final String time;

  const ChatBubble({
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
          color: isSent ? Colors.green : Colors.grey[300],
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
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
