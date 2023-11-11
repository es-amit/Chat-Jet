import 'package:chat_jet/services/database_service.dart';
import 'package:chat_jet/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({super.key,required this.adminName,required this.groupId,required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }
  String getId(String r){
    return r.substring(0,r.indexOf("_"));
  }


  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getMembers() async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupMembers(widget.groupId).then((value){
      setState(() {
        members = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text("Group Info",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),),
        actions: [
          IconButton(onPressed: (){
            print('group leaves');
          }, icon: const Icon(Icons.exit_to_app,
        color: Colors.white,))
        ],

      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            const Icon(Icons.account_circle,
            size: 150,
            color: Colors.grey,),
            Text(widget.groupName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 30,),
            const Divider(height:5,),    
            memberList(),         
          ],
        ),
        
      ),
      
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members, 
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['members'] !=null){
            if(snapshot.data['members'].length != 0){
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                itemBuilder: (context,index){
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 38,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),
                        style: const TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold),),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                });
            }
            else{
              return const Center(
              child: Text('No members'),
            );
            }
          }
          else{
            return const Center(
              child: Text('No members'),
            );
          }
        }
        else{
          return const Loading();
        }
      });
  }
}