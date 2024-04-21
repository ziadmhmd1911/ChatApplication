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
import 'package:flutter_tts/flutter_tts.dart';
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
        response(await openChat(name) , 'male');
        break;
      case 'closeChat':
        response(closeChat(), 'male');
        break;
      case 'openedChat':
        response(openedChat(),'male');
        break;
      case 'textMessage':
        response(await sendTextMessageTo(name, data['message']),'male');
        break;
      case 'voiceMessage':
        response(sendVoiceMessageTo(name, data['message']),'male');
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
      case 'block':
        response(await blockUser(name),'male');
        break;
      case 'unblock':
        response(await unblockUser(name),'male');
        break;
      default:
        response('الأمر غير موجود','male');
    }
  }

  Future<String> openChat(String name) async {
    User user = await _userController.getUserByName(name);
      if (user.id == '') {
        return 'مستخدم غير موجود';
      }
      LoggedUser().openedChat = user.full_name!;
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => ChatPage(
          receiverUserId: user.id!,
          receiverUserEmail: user.full_name!,
      )));
      
    return 'تم فتح الدردشة مع $name';
  }

  String closeChat() {
    LoggedUser().openedChat = '';
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => HomePage(userName: _loggedUser.fullName),
      ),
    );
    return 'تم إغلاق الدردشة';
  }

  String openedChat(){
    if(LoggedUser().openedChat=='')
      {
        return 'لا يوجد دردشة مفتوحة';
      }
    else
      {
        return 'الدردشة مفتوحة مع ${LoggedUser().openedChat}';
      }
  }


  Future<String> sendTextMessageTo(String name, String message) async {
    User sender = await _userController.getUserByName(name);
    if (sender.id == '') {
      return ('مستخدم غير موجود');
    }
      print(message);
      // send message to user with user.id
    return 'تم إرسال الرسالة إلى $name';
  }

  String sendVoiceMessageTo(String name, String message) {
    _userController.getUserByName(name).then((user) {
      if (user.id == '') {
        return 'مستخدم غير موجود';
      }
      // send voice message to user with user.id
    });
    return 'تم إرسال الرسالة الصوتية إلى $name';
  }

  Future<Map<String, dynamic>> unseenMessages(String name) async {
    User sender = await _userController.getUserByName(name);
    if (sender.id == '') {
      return {'error': 'مستخدم غير موجود'};
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
        return 'مستخدم غير موجود';
      }
      // call user with user.id
    });
    return 'جاري الإتصال بـ $name';
  }

  String endCall(){
    // end call
    return 'تم إنهاء المكالمة';
  }

  Future<String> blockUser(String name) async {
    User blockedUser = await _userController.getUserByName(name);
    if (blockedUser.id == '') {
      return 'مستخدم غير موجود';
    }
    return _userController.blockUser(blockedUser.id!);
  }

  Future<String> unblockUser(String name) async {
    User blockedUser = await _userController.getUserByName(name);
    if (blockedUser.id == '') {
      return 'مستخدم غير موجود';
    }
    return _userController.unblockUser(blockedUser.id!);
  }

  void response(String text, String? gender) async {
    if(gender == null)
      gender = 'male';
    FlutterTts flutterTts = FlutterTts();
    // flutterTts.speak(text);
    if (gender == 'male') {
      await flutterTts.setVoice({"name": "ar-xa-x-ard-local", "locale": "ar"});
      //Ard -> Male ,, Arz -> Female
      await flutterTts.setSpeechRate(0.5);
      // Set the volume to 1.0
      await flutterTts.setVolume(1.0);
      // Set the pitch to 1.0
      await flutterTts.setPitch(1.0);
      // Speak the message
      await flutterTts.speak(text);
    }
    else {
      await flutterTts.setVoice({"name": "ar-xa-x-arz-local", "locale": "ar"});
      //Ard -> Male ,, Arz -> Female
      await flutterTts.setSpeechRate(0.5);
      // Set the volume to 1.0
      await flutterTts.setVolume(1.0);
      // Set the pitch to 1.0
      await flutterTts.setPitch(1.0);
      // Speak the message
      await flutterTts.speak(text);
    }
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