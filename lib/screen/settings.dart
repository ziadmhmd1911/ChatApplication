import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/BlockedUsersPage.dart';
import 'package:flutter_application_1/screen/my_drawer.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.primary), // Changed color to white
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const UserHeader(
            username: 'John Doe', // Replace with the actual username
            profilePictureUrl:
                'https://example.com/profile.jpg', // Replace with the actual URL of the profile picture
          ),
          const SizedBox(
            height: 25.0,
          ),
          SettingButton(
            label: 'Change Profile Picture',
            icon: Icons.person,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text(
                          'Take Photo',
                          style: TextStyle(color: Theme.of(context).colorScheme.primary), // Changed color to white
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          // Navigate to the page to take a photo
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text(
                          'Choose from Gallery',
                          style: TextStyle(color: Theme.of(context).colorScheme.primary), // Changed color to white
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          // Navigate to the page to choose from gallery
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 25.0,
          ),
          SettingButton(
            label: 'Blocked',
            icon: Icons.block,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlockedUsersPage()),
              );
            },
          ),
          const SizedBox(
            height: 25.0,
          ),
          SettingButton(
            label: 'Help',
            icon: Icons.help,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Help", style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
                    content: Text("This is the help message.", style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close", style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 25.0,
          ),
          SettingButton(
            label: 'Invite',
            icon: Icons.share,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Invite", style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
                    content: Text("This is the invite message.", style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close", style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}

class UserHeader extends StatelessWidget {
  final String username;
  final String profilePictureUrl;

  const UserHeader({
    Key? key,
    required this.username,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profilePictureUrl),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          SizedBox(width: 20),
          Text(
            username,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.background,), // Changed color to white
          ),
        ],
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SettingButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Theme.of(context).colorScheme.primary), // Changed color to white
        label: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Changed color to white
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.background,
         )  // Set background color to white
      ),
    );
  }
}
