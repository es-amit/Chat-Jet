import 'package:chat_jet/screens/home/group_info.dart';
import 'package:chat_jet/services/database_service.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const ChatPage({super.key,required this.userName,required this.groupId,required this.groupName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {    
    super.initState();
    getChatandAdmin();
  }

  getChatandAdmin(){
    DatabaseService().getChats(widget.groupId).then((value){
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        admin = value;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.groupName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, GroupInfo(adminName: admin, groupId: widget.groupId, groupName: widget.groupName));
          }, icon: const Icon(Icons.info,
          color: Colors.white,))
        ],
      ),
    );
  }
}