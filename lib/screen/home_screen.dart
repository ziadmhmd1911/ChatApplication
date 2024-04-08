import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ChatsController.dart';
import 'package:flutter_application_1/models/Chats.dart';
import 'package:flutter_application_1/models/loggedUser.dart';
import 'package:flutter_application_1/screen/conversation_page.dart';
import 'package:flutter_application_1/screen/my_drawer.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    ChatsController chatsController = ChatsController();
    LoggedUser loggedUser = LoggedUser();
    //replage ehab with loggedUser.fullName
    String currentUser = 'ehab';

    return FutureBuilder<List<Chats>>(
      future: chatsController.getChats('ehab'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any loading indicator widget
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Chats> chatsList = snapshot.data ?? [];

          // Format current time in 12-hour format with AM/PM
          String formattedTime = DateFormat('h:mm:ss a').format(DateTime.now());

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              title: Text('Home Page', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              actions: [
                IconButton(icon: Icon(Icons.search), onPressed: () {}),
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
                          child: ListView.builder(
                            itemCount: chatsList.length,
                            itemBuilder: (context, index) {
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
                                      chatsList[index].participants[0] == currentUser
                                          ? chatsList[index].participants[1]
                                          : chatsList[index].participants[0],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          DateFormat('h:mm:ss a').format(chatsList[index].lastMessageTime),
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          chatsList[index].lastMessage,
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
                                          builder: (context) => ConversationPage(chatIndex: index),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
            drawer: const MyDrawer(),
          );
        }
      },
    );
  }
}
