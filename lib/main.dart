import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/screens/authenticate/sign_in.dart';
import 'package:chat_jet/screens/home/home.dart';
import 'package:chat_jet/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    // run the initialisation for web
    await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: Constants.apiKey,
    appId: Constants.appId, 
    messagingSenderId: Constants.messagingSenderId,
    projectId: Constants.projectId));
  }
  else{
    // run the initialization for android ,ios
    await Firebase.initializeApp();
  }
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {

  bool isSignedIn =false;
  @override

  void initState() { 
    super.initState();
    getUserLoggedInStatus();
    
  }
  getUserLoggedInStatus() async{
      await HelperFunctions.getUserLoggedInStatus().then((value){
        if(value != null ){
          setState(() {  
            isSignedIn = value;
          });
        }
      });
    }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Constants().primaryColor),
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? const HomePage() : const SignIn(),
    );
  }
}