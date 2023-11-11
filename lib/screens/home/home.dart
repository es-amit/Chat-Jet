import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/screens/authenticate/sign_in.dart';
import 'package:chat_jet/screens/home/group_tile.dart';
import 'package:chat_jet/screens/home/profile_page.dart';
import 'package:chat_jet/screens/home/search_screen.dart';
import 'package:chat_jet/services/auth.dart';
import 'package:chat_jet/services/database_service.dart';
import 'package:chat_jet/shared/loading.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Stream? groups;
  bool loading =false;
  String groupName="";


  // string manipulation
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }


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
   // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
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
                nextScreenReplace(context, ProfilePage(username: username,email: email,));
              },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: (){
          popUpDialog(context);
      },
      elevation: 0.0,
      child: const Icon(Icons.add,
      color: Colors.white,),
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context, builder: (context){
      
      return AlertDialog(
        title: const Text("Create a group",
        textAlign: TextAlign.left,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            loading ? const Loading() : TextField(
              decoration: textInputDecoration.copyWith(
                hintText: "Group Name",
              ),
              onChanged: (value) {
                setState(() {
                  groupName = value;
                });
              },
            )

          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ), 
          child: const Text('Cancel',
          style: TextStyle(
            color: Colors.white,
          ),)),
          ElevatedButton(onPressed: () async{
            if(groupName != ""){
              setState(() {
                loading = true;
              });
            }
            DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(username, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete((){
              loading=false;
            });
            Navigator.of(context).pop();
            showSnackbar(context, Colors.green, "Group Created Successfully!!");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ), 
          child: const Text('Create',
          style: TextStyle(
            color: Colors.white,
          ),)),
        ],
      );

    });

  }

  groupList(){
    return StreamBuilder(
      stream: groups, 
      builder: (context, AsyncSnapshot snapshot){
        // make some checkes

        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length != 0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context,index){
                  // to display the most recent group joined
                  int reverseIndex = snapshot.data['groups'].length- index-1;
                  return GroupTile(userName: username, groupId: getId(snapshot.data['groups'][reverseIndex]), groupName: getName(snapshot.data['groups'][reverseIndex]));
                });
            }
            else{
              return noGroupWidget();
            }

          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return const Loading();
        }
      });

  }
  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
            child: const Icon(Icons.add_circle,color: Colors.grey,
            size: 75,),
          ),
          const SizedBox(height: 20,),
          const Text("You've not joined any groups, tap on the add icon to create a group or also search from top search button",
          textAlign: TextAlign.center,)
        ],
      ),

    );
  }
}