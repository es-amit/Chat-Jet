import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth auth = FirebaseAuth.instance;

  // sign in with anon

  // register with email and password

  Future registerWithEmailandPassword(String fullName,String email,String password) async{
    try{
      User user = (await auth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      // ignore: unnecessary_null_comparison
      if(user != null){

        // call a database service to update the database
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    }on FirebaseAuthException catch(e){
     // print(e.toString());
      return e.message;
    }
  }

  // sign in with email and passsword
  Future loginWithEmailandPassword(String email,String password) async{
    try{
      User user = (await auth.signInWithEmailAndPassword(email: email, password: password)).user!;
      // ignore: unnecessary_null_comparison
      if(user != null){

        // call a database service to update the database
        return true;
      }
    }on FirebaseAuthException catch(e){
     // print(e.toString());
      return e.message;
    }
  }


  // sign out 
  Future signOut() async{
    try{
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await auth.signOut();
    }
    catch(e){
      return null;
    }
  }

}