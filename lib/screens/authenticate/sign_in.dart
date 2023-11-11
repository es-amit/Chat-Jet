
import 'package:chat_jet/helper/helper_function.dart';
import 'package:chat_jet/screens/authenticate/register.dart';
import 'package:chat_jet/screens/home/home.dart';
import 'package:chat_jet/services/auth.dart';
import 'package:chat_jet/services/database_service.dart';
import 'package:chat_jet/shared/loading.dart';
import 'package:chat_jet/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool loading = false;
  String email ='';
  String password = "";
  final formKey = GlobalKey<FormState>();
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return loading? const Loading(): Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80,horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Chat Jet',
                style: TextStyle(
                  fontSize: 40,fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 10,),
                const Text('Login now to see what they are talking',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black38
                ),),
                const SizedBox(height: 20,),
                Image.asset('assets/login.png',
                height: 180,),

                const SizedBox(height: 30,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email,
                    color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (value){
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                ),

                const SizedBox(height: 20,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,
                    color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (value){
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                ),

                const SizedBox(height: 20,),

                SigninButton(context, "Sign In"),
                
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(text: "Don't have an account ",
                  style: const TextStyle(
                    color: Colors.black,fontSize: 14
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Register here',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap =(){
                        nextScreen(context, const Register());
                      }
                    )
                  ]),
                  
                )
              ],
            ),),
        ),
      ),
    );
  }
   // ignore: non_constant_identifier_names
   Widget SigninButton(BuildContext context,String label){
    return InkWell(
      onTap: () async{

        login();
        // setState(() {
        //   loading = true;
        // });
        // dynamic result = await _auth.signInWithEmailAndPassword(_email.text, _password.text);
        // if(result == null){
        //   setState(() {
        //     loading = false;
        //     error = 'please supply a valid email';
        //   });
        // }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 0.0),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 6, 245, 66),
            Color.fromARGB(255, 84, 206, 88)
          ]),
          borderRadius: BorderRadius.circular(30),
        ),
        child:  Center(
          child: Text(label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600
          ),),
        ),
      ),
    );
  }

  login() async {
    if(formKey.currentState!.validate()){
      if(formKey.currentState!.validate()){
      setState(() {
        loading = true;
      });
      await auth.loginWithEmailandPassword(email, password)
      .then((value) async{
        if(value == true){
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomePage());

        }
        else{
          showSnackbar(context, Colors.red, value);
          setState(() {
            loading=false;
          });
        }
      });
    }
  }
    }
  }