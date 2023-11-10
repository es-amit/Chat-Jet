import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});


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
}