import 'package:flutter_application_1/models/Chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/loggedUser.dart';


class ChatsController {
  final CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  LoggedUser loggedUser = LoggedUser();

  Future<List<Chats>> getChats() async {
    QuerySnapshot snapshot = await chats.where('').get();
    List<Chats> chatList = [];
    snapshot.docs.forEach((doc) {
      Chats chat = Chats(sender1: doc['sender1'], 
                         sender2: doc['sender2'], 
                         lastMessage: doc['lastMessage'], 
                         lastMessageTime: doc['lastMessageTime']
                        );
      chatList.add(chat);
    });
    return chatList;
  }

  static Future<void> createChat(Chats chat) async {
    // Create chat on the server
  }
  
 /* static Future<void> sendMessage(Chat chat, String message) async {
    // Send message to the server
  }
  
  static Future<void> deleteChat(Chat chat) async {
    // Delete chat from the server
  }
  
  
  static Future<void> updateChat(Chat chat) async {
    // Update chat on the server
  }
  
  static Future<void> markAsRead(Chat chat) async {
    // Mark chat as read on the server
  }
  
  static Future<void> markAsUnread(Chat chat) async {
    // Mark chat as unread on the server
  }
  
  static Future<void> markAsImportant(Chat chat) async {
    // Mark chat as important on the server
  }
  
  static Future<void> markAsUnimportant(Chat chat) async {
    // Mark chat as unimportant on the server
  }
  
  static Future<void> markAsStarred(Chat chat) async {
    // Mark chat as starred on the server
  }
  
  static Future<void> markAsUnstarred(Chat chat) async {
    // Mark chat as unstarred on the server
  }
  
  static Future<void> markAsArchived(Chat chat) async {
    // Mark chat as archived on the server
  }
  
  static Future<void> markAsUnarchived(Chat chat) async {
    // Mark chat as unarchived on the server
  }
  
  static Future<void> markAsDeleted(Chat chat) async {
    // Mark chat as deleted on the server
  }
  
  static Future<void> markAsUndeleted(Chat chat) async {
    // Mark chat as undeleted on the server
  }
  
  static Future<void> markAsMuted(Chat chat) async {
    // Mark chat as muted on the server
  }
  
  static Future<void> markAsUnmuted(Chat chat) async {
    // Mark chat as unmuted on the server
  }
  
  static Future<void> markAsPinned(Chat chat) async {
    // Mark chat as pinned on the server
  }
  
  static Future<void> markAsUnpinned(Chat chat) async {
    // Mark chat as unpinned
  }*/

}

// create main function to test the code
void main() async {
  
  CollectionReference users = FirebaseFirestore.instance.collection('chats');
  Future<void> addUser() {
      return users
          .add({
            'sender1': 'john doe', // John Doe
            'sender2':'zaky', // Stokes and Sons
            'phone': '01011', // 42
            'gender' : 'gender'
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
    addUser();
}
