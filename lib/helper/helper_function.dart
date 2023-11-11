import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{


  //keys

  static String userLoggedInKey = "Loggedinkey";
  static String userNameKey = 'Usernamekey';
  static String userEmailKey = 'userEmailkey';


  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isuserLoggedIn) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isuserLoggedIn);

  }

  static Future<bool> saveUserNameSF(String userName) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);

  }

  static Future<bool> saveUserEmailSF(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);

  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSf() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSf() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}