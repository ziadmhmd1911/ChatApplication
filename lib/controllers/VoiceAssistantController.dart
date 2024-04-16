import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/controllers/ChatsController.dart';
import 'package:flutter_application_1/controllers/UserController.dart';
import 'package:flutter_application_1/screen/conversation_page.dart';
import 'package:http/http.dart' as http;

class VoiceAssitantController {
  String _api = 'http://127.0.0.1:5000';
  ChatsController _chatsController = ChatsController();
  static BuildContext? context;
  UserController _userController = UserController();

  VoiceAssitantController({String? api}) {
    if (api != null) {
      _api = api;
    }
  }
  static void setContext(BuildContext ctx) {
    context = ctx;
  }
  Future<Map<String, dynamic>> getCommandAndName(String text) async {
    final url = Uri.parse('$_api/get-command-and-name');
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

  String openChat(String name) {
    _userController.getUserByName(name).then((user) {
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
      
    });
    return 'Opening chat with $name';
  }

  String closeChat() {
    if (Navigator.of(context!).canPop()) {
      final currentRoute = ModalRoute.of(context!)!.settings;
      if (currentRoute.name == 'ChatPage') {
        Navigator.of(context!).pop();
      }
    }
    return 'Closing chat';
  }
}

// main function to test the VoiceAssistantController

void main() async {
  final controller = VoiceAssitantController();
  final data = await controller.getCommandAndName('اتصل على احمد علي');
  print(data);
}