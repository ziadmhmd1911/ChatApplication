import 'package:flutter_application_1/models/Chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/loggedUser.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


class ChatsController {
  
  final CollectionReference chatRooms = FirebaseFirestore.instance.collection('chatRooms');
  LoggedUser loggedUser = LoggedUser();

  Future<List<Chats>> getChats(String user) async {
    QuerySnapshot snapshot = await chatRooms
      .where('participants', arrayContains: user)
      .orderBy('lastMessageTime', descending: false)
      .get();
    List<Chats> chatList = [];
    snapshot.docs.forEach((doc) {
      Chats chat = Chats(participants: doc['participants'].cast<String>(), 
                         lastMessage: doc['lastMessage'], 
                         lastMessageTime: doc['lastMessageTime'].toDate(),
                         IDs: doc['IDs'].cast<String>()
                        );
      chatList.add(chat);
      print(chat);
    });
    return chatList;
  }


  Future<void> createChatWithMessage(List<String> participants, String receiverId, String message) {
    // Create a new chat document in 'chatRooms' collection
    chatRooms.add({
      'participants': participants,
      'IDs': [loggedUser.id, receiverId],
      'lastMessage': message,
      'lastMessageTime': DateTime.now()
    }).then((docRef) {
      // Add the first message to this chat's 'messages' subcollection
      docRef.collection('messages').add({
        'receiverId': receiverId,
        'senderEmail': loggedUser.email,
        'senderId': loggedUser.id,
        'message': message,
        'seen': false, 
        'time': DateTime.now(),
      }).then((value) => print('message added successfully')).catchError((error) => print(error));
    }).catchError((error) => print(error));
    return Future(() => null);
  }

  //search for name that starts with the entered string
  Future<List<Chats>> searchForChat(String enteredString) async {
    enteredString = enteredString.trim();
    QuerySnapshot snapshot = await chatRooms
    //search for the entered string and logggedUser.fullname in the participants array
      .where('participants', arrayContains: loggedUser.fullName)
      .orderBy('lastMessageTime', descending: false)
      .get();
    List<Chats> chatList = [];
    snapshot.docs.forEach((doc) {
      List<String> participants = doc['participants'].cast<String>();
      if((doc['participants'][0] == loggedUser.fullName && participants[1].startsWith(enteredString)) || 
      (doc['participants'][1] == loggedUser.fullName && participants[0].startsWith(enteredString)))
      {
        Chats chat = Chats(participants: participants, 
                          lastMessage: doc['lastMessage'], 
                          lastMessageTime: doc['lastMessageTime'].toDate(),
                          IDs: doc['IDs'].cast<String>()
                          );
        chatList.add(chat);
      }
    });
    return chatList;

  }
}

// create main function to test the code
void main() async {
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ChatsController chatsController = ChatsController();

  /*// Test createChatWithMessage
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();
  // wait for 2 seconds
  await Future.delayed(Duration(seconds: 2));
  await chatsController.createChatWithMessage();*/
  LoggedUser loggedUser = LoggedUser();
  //loggedUser.setAttributes('ehab', 'male', '01093937083','te@ad', '1');

  // Test getChats
  List<Chats> chatList = await chatsController.searchForChat('m');
  chatList.forEach((chat) {
    print(chat.participants);
    print(chat.lastMessage);
    print(chat.lastMessageTime);
  });
}