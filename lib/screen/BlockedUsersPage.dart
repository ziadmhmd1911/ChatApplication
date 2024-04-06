import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/my_drawer.dart';

class BlockedUsersPage extends StatefulWidget {
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final List<String> _blockedUsers = [
    'Blocked User 1',
    'Blocked User 2',
    'Blocked User 3',
  ]; // Example list of blocked users

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
              color: Theme.of(context).colorScheme.background), // Changed color to white
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        color: Colors.white, // Change background color here
        child: _blockedUsers.isEmpty
            ? const Center(
                child: Text(
                  'No users blocked',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            : ListView.builder(
                itemCount: _blockedUsers.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: index % 2 == 0
                        ? Colors.white // Even index
                        : Colors.grey[200], // Odd index
                    child: ListTile(
                      title: Text(_blockedUsers[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _unblockUser(index);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white, // Change drawer background color here
        ),
        child: const MyDrawer(),
      ),
    );
  }

  void _unblockUser(int index) {
    setState(() {
      _blockedUsers.removeAt(index); // Remove user from the list of blocked users
    });
    // Implement logic to unblock the user (e.g., send request to server)
  }
}
