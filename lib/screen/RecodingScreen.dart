import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat/chat_service.dart';
import 'package:flutter_application_1/controllers/SpeechToTextController.dart';
import 'package:flutter_application_1/models/User.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';



class FullScreenButtonPage extends StatefulWidget {
  final User receiver;
  const FullScreenButtonPage({
    Key? key,
    required this.receiver,
  }) : super(key: key);
  @override
  _FullScreenButtonPageState createState() => _FullScreenButtonPageState();
}

class _FullScreenButtonPageState extends State<FullScreenButtonPage> {
  ChatService _chatService = ChatService();
  final record = AudioRecorder();
  String path = '';
  String url = '';
  bool isRecording = false;
  bool isPlaying = false;
  SpeechToTextController _STT = SpeechToTextController();

 
  @override
  void initState() {
    super.initState();
    startRecord();
    print("FullScreenButtonPage has been loaded!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            
          ),
          onPressed: () async{
            await stopRecord();
            sendVoice();
            Navigator.pop(context);
          },
          child: Text(
            'انهاء التسجيل',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  startRecord() async {
    final location = await getApplicationDocumentsDirectory();
    String name = Uuid().v1();
    if (await record.hasPermission()) {
      setState(() {
        isRecording = true;
      });
      await record.start(RecordConfig(), path: '${location.path}/$name.m4a');
    }
    print("بدايه التسجيل");
  }

  stopRecord() async {
    String? finalPath = await record.stop();
    setState(() {
      path = finalPath!;
      isRecording = false;
    });
    print("توقف التسجيل");
    await upload(); // Await upload function call
  }

  upload() async {
    String name = basename(path);
    final ref = FirebaseStorage.instance.ref('Voice' + name);
    await ref.putFile(File(path!));
    String downloadUrl = await ref.getDownloadURL();
    setState(() {
      url = downloadUrl;
    });
    print("تم التحميل");
  }

  void sendVoice() async {
    if (url.startsWith('https://firebasestorage.googleapis.com/')) {
      await _chatService.SendMessage(widget.receiver.id!, url);
      _STT.response('تم إرسال رسالة صوتية الى '+widget.receiver.full_name!, 'male');
    }
    else{
      _STT.response('حدث خطأ أثناء إرسال الرسالة الصوت','male');
    }
  }
}
