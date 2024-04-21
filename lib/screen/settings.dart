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
          'الاعدادات',
          style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .primary), // Changed color to white
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const UserHeader(
            username: 'شهد', // Replace with the actual username
            profilePictureUrl:
                'https://example.com/profile.jpg', // Replace with the actual URL of the profile picture
          ),
          const SizedBox(
            height: 25.0,
          ),
          SettingButton(
            label: 'تغيير الصوره الشخصيه',
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
                          'التقاط صوره',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary), // Changed color to white
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          // Navigate to the page to take a photo
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text(
                          'اختيار من الصور',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary), // Changed color to white
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
            label: 'قائمه المحظورين',
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
            label: 'مساعده',
            icon: Icons.help,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "مساعده",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ), // Changed color to white
                    content: Text(
                      "support@gmail.com هل تحتاج مساعده؟ تواصل معانا علي  ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ), // Changed color to white
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "اغلق",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ), // Changed color to white
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
            label: 'دعوه',
            icon: Icons.share,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "دعوه",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ), // Changed color to white
                    content: Text(
                      "انضم إلى تطبيق الدردشة الخاص بنا وابدأ في التواصل مع الأصدقاء! قم بتنزيله الآن من App Store أو Google Play Store.",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ), // Changed color to white
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "اغلق",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ), // Changed color to white
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background,
            ), // Changed color to white
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
          icon: Icon(icon,
              color: Theme.of(context)
                  .colorScheme
                  .primary), // Changed color to white
          label: Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ), // Changed color to white
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
          ) // Set background color to white
          ),
    );
  }
}
