import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/screens/authenticate/sign_in.dart';
import 'package:chat_jet/screens/home/profile_page.dart';
import 'package:chat_jet/screens/home/search_screen.dart';
import 'package:chat_jet/services/auth.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username ='';
  String email = "";
  AuthService auth = AuthService();


  getinputUserData() async{
   await HelperFunctions.getUserEmailFromSf().then((value){
    setState(() {
      email = value!;
    });
   });
   await HelperFunctions.getUserNameFromSf().then((value){
    setState(() {
      username = value!;
    });
   });
  }


  @override

  void initState() {
    super.initState();
    getinputUserData();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          nextScreen(context, const SearchPage());

        }, icon: const Icon(Icons.search))],
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Groups',
        style: TextStyle(color: Colors.white,
        fontSize: 27,
        fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(Icons.account_circle,
            size: 150,
            color: Colors.grey,),
            Text(username,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),

            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(
              onTap: (){
                Navigator.pop(context);
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
              style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreen(context, const ProfilePage());
              },
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text("Profile",
              style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () async{
                showDialog(context: context,
                 builder: (context){
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure want to logout?'),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.cancel),
                      color: Colors.red,),

                      IconButton(onPressed: (){
                        auth.signOut().whenComplete((){
                          nextScreenReplace(context, const SignIn());
                        });
                        
                      }, icon: const Icon(Icons.exit_to_app),
                      color: Colors.green,),
                    ],
                  );
                 });
                // auth.signOut().whenComplete((){
                //   nextScreenReplace(context, const SignIn());
                // });
                
              },
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Log out",
              style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}