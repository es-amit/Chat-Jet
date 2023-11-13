import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/screens/home/chat.dart';
import 'package:chat_jet/services/database_service.dart';
import 'package:chat_jet/shared/loading.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  String userName='';
  User? user;
  bool isJoined = false;
  bool loading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched= false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  // String manipulation
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  getCurrentUserIdandName() async{
    await HelperFunctions.getUserNameFromSf().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Search',
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [Expanded(child:
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white,
                fontSize: 18),
                decoration: InputDecoration(
                  labelText: "Search groups....",
                  labelStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.white
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue,width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade500,width: 2)
                  )
                )
              )),
              GestureDetector(
                onTap: () {
                  initiateSearchMethod();
                  
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(Icons.search,
                  color: Colors.white,),
              
                ),
              )
              ],
            ),
          ),
          loading ? const Loading() : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async{
    if(searchController.text.isNotEmpty){
      setState(() {
        loading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          loading =false;
          hasUserSearched = true;
        });
        
      });
    }

  }

  groupList(){
    return hasUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context,index){
        return groupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['admin']    
        );
      }): Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(String userName,String groupId, String groupName,String admin){

    // function to check whether user already exits in group
    joinedOrNot(userName,groupId,groupName,admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 30,
        child: Text(groupName.substring(0,1),
        style: const TextStyle(fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white),),),

        title: Text(groupName,style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),),
        subtitle: Text("Admin: ${getName(admin)}",
        style: const TextStyle(
          fontSize: 13
        ),),

        trailing: InkWell(
          onTap: () async{
            await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
            if(isJoined){
              setState(() {
                isJoined = !isJoined;
              });
              showSnackbar(context, Colors.red, "Successfully joined the group!!");
              Future.delayed(const Duration(seconds: 2),(){
                nextScreen(context, ChatPage(userName: userName, groupId: groupId, groupName: groupName));
              });
            }
            else{
              setState(() {
                isJoined = !isJoined;
              });
              showSnackbar(context, Colors.red, "Left the group $groupName");
            }

          },
          child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text("Join Now",
                    style: TextStyle(color: Colors.white)),
              ),
      ),
        
    );
  }
}