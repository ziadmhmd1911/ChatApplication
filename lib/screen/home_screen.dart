import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/conversation_page.dart';
import 'package:flutter_application_1/screen/my_drawer.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      itemCount: 10, // Display 10 persons
                      itemBuilder: (context, index) {
                        // Replace this with your person widget
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
                                'Person ${index + 1}',
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
                                    'Message: Hello there!',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ), // Replace with actual message
                                ],
                              ),
                              onTap: () {
                                // Action when person is tapped
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
}
