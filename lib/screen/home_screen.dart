import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/conversation_page.dart'; // Import the ConversationPage widget
import 'package:flutter_application_1/screen/my_drawer.dart';
import 'package:flutter_application_1/screen/signin_screen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final String userName;

  HomePage({Key? key, required this.userName}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // get Current UserId
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm:ss a').format(DateTime.now());

    Future<List<Map<String, String>>> getAllUserData(String currentUser) async {
      final firestore = FirebaseFirestore.instance;
      final userCollection = firestore.collection('users');

      final querySnapshot = await userCollection.where('Id', isNotEqualTo: currentUser).get();

      final userData = querySnapshot.docs.map((doc) {
        return {
          'id': doc['Id'] as String,
          'username': doc['full_name'] as String,
        };
      }).toList();

      return userData;
    }

    // Get All chatRooms For Current User
    Future<List<Map<String, String>>> getAllChatRooms(String currentUser) async {
      final firestore = FirebaseFirestore.instance;
      final chatRoomsCollection = firestore.collection('chatRooms');
      // (Received ID_SENDERID) || (SENDERID_ID_RECIVERID)
      final querySnapshot = await chatRoomsCollection.where('participants', arrayContains: currentUser).get();
      final List<Map<String, String>> chatRoomsData = []; // Change to Map<String, String> to store chatRoomId and usernames
      querySnapshot.docs.forEach((doc) {
        final participants = doc['participants'] as List<dynamic>;
        String chatRoomiidd;
        // Check if the participants list contains the current user's ID
        if (participants.contains(currentUser)) {
          final chatRoomId = doc.id;
          if (chatRoomId.split('_')[0] == currentUserId) {
            print("Condition One");
            print(currentUserId);
            chatRoomiidd = chatRoomId.split('_')[1];
            print(chatRoomiidd);
          } else {
            print("Condition Two");
            print(currentUserId);
            chatRoomiidd = chatRoomId.split('_')[0];
            print(chatRoomiidd);
          }
          final List<String> UserNames = [];
          participants.forEach((element) {
            if (element != currentUser) {
              UserNames.add(element);
            }
          });
          // Add chatRoomId and usernames to chatRoomsData list
          //Sender_Receiver(chatrromid)
          chatRoomsData.add({
            'UserId': chatRoomiidd,
            'userNames': UserNames.join(', '), // Convert List<String> to comma-separated string
            'LastMessage': doc['lastMessage'] as String,
          });
        }
      });
      print(chatRoomsData);
      return chatRoomsData;
    }

    // getAllChatRooms(userName);
  final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          userName,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            List<Map<String, String>> userNames = await getAllUserData(currentUserName);
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: userNames.length,
                    itemBuilder: (context, index) {
                      String id = userNames[index]['id']!;
                      String userName = userNames[index]['username']!;
                      return ListTile(
                        title: Text(userName),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverUserId: id,
                                receiverUserEmail: userName,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Color(0xFFEFFFFC),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FutureBuilder<List<Map<String, String>>>(
                      future: getAllChatRooms(userName),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                        List<Map<String, String>> userData = snapshot.data!;
                        return ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            String id = userData[index]['UserId']!;
                            String userName = userData[index]['userNames']!;
                            String LastMessage = userData[index]['LastMessage']!;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage: AssetImage('assets/person_image.png'), // Replace with your image
                                  ),
                                  title: Text(
                                    userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        'Last seen: $formattedTime',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        LastMessage,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          receiverUserId: id,
                                          receiverUserEmail: userName,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.edit_outlined,
            size: 25,
          ),
          onPressed: () {},
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
