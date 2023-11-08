import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{


  //keys

  static String userLoggedInKey = "Loggedinkey";
  static String userNameKey = 'Usernamekey';
  static String userEmailKey = 'userEmailkey';


  // saving the data to SF


  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}