import 'package:chat_jet/screens/authenticate/sign_in.dart';
import 'package:chat_jet/services/auth.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            auth.signOut();
            nextScreenReplace(context, const SignIn());
          },
          child: const Text('log out'),),

      )
    );
  }
}