import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/services/database_service.dart';
import 'package:chat_jet/shared/loading.dart';
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

  bool loading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched= false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
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
          loading ? Loading() : groupList()
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
        searchSnapshot = snapshot;
        setState(() {
          loading =false;
        });
        hasUserSearched = true;
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

  Widget groupTile(String userName,String groupId, String groupName,String admin){
    return Text('hello');


  }
}