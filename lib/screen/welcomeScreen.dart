import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screen/signin_screen.dart';
import 'package:flutter_application_1/screen/signup_screen.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/widgets/CustomScaffold.dart';
import 'package:flutter_application_1/widgets/Welcome_button.dart';
import 'package:flutter_application_1/theme/theme.dart';

void main() {
  runApp(const WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome Back!\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text:
                                '\nChat with your friends and family\nusing our messaging app.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
        )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child:WelcomeButton(
                      buttonText: 'Sign in' ,
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    )
                    ),
                  Expanded(
                    child:WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,   
                      textColor: lightColorScheme.primary,
        
                    )
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );  
  }
}