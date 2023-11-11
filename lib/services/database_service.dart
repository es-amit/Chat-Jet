import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String? uid;
  DatabaseService({this.uid});


  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');
  // updating the userdata
  Future savingUserData(String fullname,String email ) async{

    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups":[],
      "profilePic":"",
      "uid":uid
    }
    );

  }

  // getting user data
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await userCollection.where('email',isEqualTo: email).get();
    return snapshot;
  }

  // getting user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String userName,String id,String groupName) async{
    DocumentReference groupdocumentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon':"",
      'admin': "${id}_$userName",
      'members':[],
      'groupId':"",
      'recentMessage':"",
      'recentMessageSender':"",
    });

    // update the members
    await groupdocumentReference.update({
      'members': FieldValue.arrayUnion(["${uid}_$userName"]),
      'groupId': groupdocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      'groups':FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }

  // gettting the chats

  getChats(String groupId) async{
    return groupCollection
    .doc(groupId)
    .collection('messages')
    .orderBy("time");
  }

  Future getGroupAdmin(String groupId) async{
    DocumentReference d= groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(String groupId) async{
    return groupCollection.doc(groupId).snapshots();
  }


  // search 
  searchByName(String groupName){
    return groupCollection.where('groupName',isEqualTo: groupName).get();
  }

  // function -> bool

  Future<bool> isUserJoined(String groupName,String groupId,String userName)async{
    DocumentReference userdocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userdocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;
    }
    else{
      return false;
    }

  }


}