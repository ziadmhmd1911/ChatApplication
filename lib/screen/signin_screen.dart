import 'dart:convert';
import 'dart:typed_data';
import 'package:speech_to_text/speech_to_text.dart'; // Import speech_to_text package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/CustomScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import home screen
import 'home_screen.dart';
//import chatService
import 'package:flutter_application_1/chat/chat_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignState();
}
  String currentUserName = "";

// Function to get loggedin user username
String loggedinuser() {
  return currentUserName;
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

  Future<void> loginUser(BuildContext context) async {
  try {
    //Unhash Password
    String unhashedPassword = hashPassword(password.text);
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userName.text,
      password: unhashedPassword,
    );
    // Get the user name from the database
    final user = FirebaseAuth.instance.currentUser;
    final userDocument = await users.doc(user!.uid).get();
    currentUserName = userDocument['full_name'];

    // If login is successful, print a success message
    print("User LoggedIn Successfully!");
    // Navigate to the home screen and send user name
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(userName: currentUserName),
      ),
    );
    startListening();
  } catch (error) {
    // Handle login errors
    print("Failed to login user: $error");
  }
}

void startListening() {
  SpeechToText _speech = SpeechToText();

  _speech.initialize().then((_) {
    if (_speech.isAvailable) {
      // Define a function to handle speech recognition
      void listenForSpeech() {
        _speech.listen(
          localeId: 'ar', // Specify Arabic locale
          onResult: (result) {
            if (result.finalResult) {
              print("You said: ${result.recognizedWords}");
              // Handle the recognized speech here
              if (result.recognizedWords == "السلام عليكم") {
                _speech.stop();
                print("Speech recognition stopped.");
              } else {
                // If the phrase is not recognized, continue listening
                listenForSpeech();
              }
            }
          },
        );
      }

      // Start listening for speech
      listenForSpeech();
    } else {
      print("Speech recognition not available");
    }
  }).catchError((error) {
    print("Error initializing speech recognition: $error");
  });
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
                            loginUser(context);
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
