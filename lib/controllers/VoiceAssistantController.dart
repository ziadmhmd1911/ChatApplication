import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/controllers/ChatsController.dart';
import 'package:flutter_application_1/controllers/UserController.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/models/User.dart';
import 'package:flutter_application_1/models/loggedUser.dart';
import 'package:flutter_application_1/screen/conversation_page.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:http/http.dart' as http;

class VoiceAssitantController {
  ChatsController _chatsController = ChatsController();
  static BuildContext? context;
  UserController _userController = UserController();
  LoggedUser _loggedUser = LoggedUser();
  static String _api = 'http://10.0.2.2:5000';
  HttpClient _httpClient = HttpClient();

  Future<Map<String, dynamic>> getCommandAndName(String text) async {
    final url = Uri.parse('$_api/get-command-and-name');
    print('url:' + url.toString());
    final response = await http.post(
      url,
      body: json.encode({'text': text}), // Encode the body as JSON
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to get command and name');
    }
  }

  // get the command and name using _httpClient
  Future<Map<String, dynamic>> getCommandAndName2(String text) async {
    final url = Uri.parse('$_api/get-command-and-name');
    final request = await _httpClient.postUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.write(json.encode({'text': text}));
    final response = await request.close();
    if (response.statusCode == 200) {
      final data = await response.transform(utf8.decoder).join();
      return json.decode(data);
    } else {
      throw Exception('Failed to get command and name');
    }
  }

  VoiceAssitantController({String? api}) {
    if (api != null) {
      _api = api;
    }
  }

  static void setContext(BuildContext ctx) {
    context = ctx;
  }


  void excuteCommand(Map<String, dynamic> data) async {
    final command = data['command'];
    final name = data['name'];
    switch (command) {
      case 'openChat':
        print(await openChat(name));
        break;
      case 'closeChat':
        closeChat();
        break;
      case 'sendTextMessageTo':
        sendTextMessageTo(name, data['message']);
        break;
      case 'sendVoiceMessageTo':
        sendVoiceMessageTo(name, data['message']);
        break;
      case 'unseenMessages':
        unseenMessages(name);
        break;
      case 'call':
        call(name);
        break;
      case 'endCall':
        endCall();
        break;
      default:
        print('Command not found');
    }
  }

  Future<String> openChat(String name) async {
    User user = await _userController.getUserByName(name);
      if (user.id == '') {
        return 'User not found';
      }
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => ChatPage(
          receiverUserId: user.id!,
          receiverUserEmail: user.full_name!,
      )));
      
    return 'Opened chat with $name';
  }

  String closeChat() {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => HomePage(userName: _loggedUser.fullName),
      ),
    );
    return 'Chat is closed';
  }

  String sendTextMessageTo(String name, String message) {
    _userController.getUserByName(name).then((user) {
      if (user.id == '') {
        return 'User not found';
      }
      // send message to user with user.id
    });
    return 'Message sent to $name';
  }

  String sendVoiceMessageTo(String name, String message) {
    _userController.getUserByName(name).then((user) {
      if (user.id == '') {
        return 'User not found';
      }
      // send voice message to user with user.id
    });
    return 'Voice message sent to $name';
  }

  Future<Map<String, dynamic>> unseenMessages(String name) async {
    User sender = await _userController.getUserByName(name);
    if (sender.id == '') {
      return {'error': 'User not found'};
    }
    String cahtId = await _chatsController.getChatId(sender.id!);
    return {
      'unseenMessagesIds': _chatsController.getUnseenMessagesIds(cahtId),
      'chatId': cahtId,
      'senderId': sender.id,
    };
  }

  String call(String name) {
    _userController.getUserByName(name).then((user) {
      if (user.id == '') {
        return 'User not found';
      }
      // call user with user.id
    });
    return 'Calling $name';
  }

  String endCall(){
    // end call
    return 'Call ended';
  }
}

// main function to test the VoiceAssistantController

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LoggedUser().setAttributes('ehab', 'male', '01093937083', 'ehab@gmail.com', 'aidxZmxcZhbcb7gX8gCWluEQVsA2');
  final controller = VoiceAssitantController();
  final data = await controller.getCommandAndName('اتصل على احمد علي');
  print(data);
  print(await controller.unseenMessages('bely'));
}