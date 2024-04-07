import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/CustomScaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignState();
}

class _SignState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String hashPassword(String password) {
      // Convert password to bytes
      Uint8List passwordBytes = utf8.encode(password);

      // Hash the password using SHA-256
      Digest hashedPassword = sha256.convert(passwordBytes);

      // Return the hashed password as a string
      return hashedPassword.toString();
    }

  Future<void> loginUser() {
  return users
      .where('full_name', isEqualTo: userName.text)
      .get()
      .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // User with the given full_name exists, check the password
          String hashedPassword = hashPassword(password.text);
          String storedPassword = querySnapshot.docs[0]['password'];

          if (hashedPassword == storedPassword) {
            print("User LoggedIn Successfully!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            print("Incorrect password!");
          }
        } else {
          print("User not found!");
        }
      })
      .catchError((error) => print("Failed to login user: $error"));
}
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
        const Expanded(
          flex : 1,
          child: SizedBox(
            height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Form(
                key: _formSignInKey,
                child: Column(
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color:lightColorScheme.primary,
                      ),
                    ),  
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: userName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Username'),
                          hintText: 'Username',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberPassword,
                              onChanged: (bool? value) {
                                setState(() {
                                  rememberPassword = value!;
                                });
                              },
                              activeColor: lightColorScheme.primary,
                            ),
                            const Text(
                              'Remember Password',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),         
                      ],
                    ),
                      GestureDetector(
                      child: Text(
                        'Forget password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: lightColorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            loginUser();
                            if (_formSignInKey.currentState!.validate() &&
                                rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Welcome back!'),
                                ),
                              );
                            } else if (!rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Wrong data, please check your data')),
                              );
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 25.0,
                    ),
                  ],                   
                ),                
              ),                            
            ),
          ),
        ],
      )
    );
  }
}
