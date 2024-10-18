import 'package:abhiman_assignment/features/auth/presentation/screens/login_page.dart';
import 'package:abhiman_assignment/features/auth/presentation/screens/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially
  bool showLoginPage = true;

  //toggle between pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onPress: togglePages);
    } else {
      return SignupPage(onPress: togglePages);
    }
  }
}
