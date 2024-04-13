import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/settings.dart';
import 'package:flutter_application_1/screen/signin_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "Ahmed";
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child:Icon(
                Icons.message,color: Theme.of(context).colorScheme.background,
                size: 40,
              ),
            ),       
          ),
          const SizedBox(
            height: 25.0,
          ),
          Padding(
            padding:const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text('Home',style: TextStyle(color: Theme.of(context).colorScheme.background),),
              leading: Icon(Icons.home,color: Theme.of(context).colorScheme.background,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(userName: userName)));
              },
            ),
          ),
          const SizedBox(
            height: 25.0,
          ), 
          Padding(
            padding:const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text('Settings',style: TextStyle(color: Theme.of(context).colorScheme.background),),
              leading: Icon(Icons.settings,color: Theme.of(context).colorScheme.background,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));},
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Padding(
            padding:const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text('Log Out',style: TextStyle(color: Theme.of(context).colorScheme.background),),
              leading: Icon(Icons.logout,color: Theme.of(context).colorScheme.background,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignInScreen()));},
            ),
          ),
        ]
      )
    );
  }
}
