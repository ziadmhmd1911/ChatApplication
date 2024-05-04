import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechToTextController {
  Future<void> blockingResponse(String text, String? gender) async {
    if(gender == null)
      gender = 'male';
    FlutterTts flutterTts = FlutterTts();
    // flutterTts.speak(text);
    if (gender == 'male') {
      await flutterTts.setVoice({
      "name": "ar-xa-x-ard-local",
      "locale": "ar"
    }); // Ard -> Male ,, Arz -> Female
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Use a Completer to wait for audio completion
    Completer<void> completer = Completer<void>();

    // Set up onComplete callback
    flutterTts.setCompletionHandler(() {
      print("Audio completed!");
      completer.complete(); // Complete the Future when audio is done
    });

    // Start speaking
    await flutterTts.speak(text);

    // Wait until audio completion
    await completer.future;
      
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



  Future<void> playAudio(String url) async {
    final player = AudioPlayer();

    // Use a Completer to wait for audio completion
    Completer<void> completer = Completer<void>();

    // Set up completion callback
    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        print("Audio completed!");
        completer.complete(); // Complete the Future when audio is done
      }
    });

    // Start playing audio
    player.play(UrlSource(url)); // Assuming url is a network url

    // Wait until audio completion
    await completer.future;

    // Dispose the player after playback
    player.dispose();
  }

}
