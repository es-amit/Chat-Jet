import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/screens/authenticate/sign_in.dart';
import 'package:chat_jet/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    // run the initialisation for web
    await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyCkL4vSmF_0xA3dnJYqlBgt2nZfFcan9Pk",
    appId: "1:810574724125:android:4ff7399bf5f9e6d3461af4", 
    messagingSenderId: "810574724125",
    projectId: "chat-jet-34c03"));
  }
  else{
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
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
    
  }
  getUserLoggedInStatus() async{
      await HelperFunctions.getUserLoggedInStatus().then((value){
        if(value != null ){
          isSignedIn = value;
        }
      });
    }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? Home() : SignIn(),
    );
  }
}