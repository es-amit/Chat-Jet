import 'package:chat_jet/screens/authenticate/sign_in.dart';
import 'package:chat_jet/screens/home/home.dart';
import 'package:chat_jet/services/auth.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {

  String username;
  String email;
  ProfilePage({super.key,required this.username,required this.email});
  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  


  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile",
        style: TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.bold
        ),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(Icons.account_circle,
            size: 150,
            color: Colors.grey,),
            Text(widget.username,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),

            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(
              onTap: (){
                nextScreenReplace(context, const HomePage());
              },
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
              style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text("Profile",
              style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () async{
                showDialog(
                  barrierDismissible: false,
                  context: context,
                 builder: (context){
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure want to logout?'),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.cancel),
                      color: Colors.red,),

                      IconButton(onPressed: ()async{
                        await auth.signOut().whenComplete((){
                          nextScreenReplace(context, const SignIn());
                        });
                        
                      }, icon: const Icon(Icons.exit_to_app),
                      color: Colors.green,),
                    ],
                  );
                 });
                
              },
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Log out",
              style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,
            size: 200,
            color: Colors.grey[700],),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Full Name',
                style: TextStyle(fontSize: 17),),
                Text(widget.username,
                style: const TextStyle(fontSize: 17),),
              ],
            ),
            const Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email',
                style: TextStyle(fontSize: 17),),
                Text(widget.email,
                style: const TextStyle(fontSize: 17),),
              ],
            ),
          ],
        ),
      ),
    );
     
  }
}