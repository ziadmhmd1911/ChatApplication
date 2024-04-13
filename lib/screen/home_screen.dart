import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/conversation_page.dart'; // Import the ConversationPage widget
import 'package:flutter_application_1/screen/my_drawer.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final String userName;

  HomePage({Key? key, required this.userName}) : super(key: key);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm:ss a').format(DateTime.now());

    Future<List<String>> getAllUserNames(String currentUser) async {
      final firestore = FirebaseFirestore.instance;
      final userCollection = firestore.collection('users');
      final querySnapshot = await userCollection.where('full_name', isNotEqualTo: currentUser).get();
      final names = querySnapshot.docs.map((doc) => doc['full_name'] as String).toList();
      return names;
    }

    Future<List<String>> getAllIds(String currentUser) async {
      final firestore = FirebaseFirestore.instance;
      final userCollection = firestore.collection('users');
      final querySnapshot = await userCollection.where('Id', isNotEqualTo: currentUser).get();
      final Ids = querySnapshot.docs.map((doc) => doc['Id'] as String).toList();
      return Ids;
    }

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
                    child: FutureBuilder<List<dynamic>>(
                      future: Future.wait([
                        getAllIds(userName),
                        getAllUserNames(userName),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        List<dynamic> data = snapshot.data!;
                        List<String> ids = data[0] as List<String>;
                        List<String> userNames = data[1] as List<String>;

                        return ListView.builder(
                          itemCount: userNames.length,
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
                                    userNames[index],
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
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          receiverUserId: ids[index],
                                          receiverUserEmail: userNames[index],
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
      drawer: const MyDrawer(),
    );
  }
}
