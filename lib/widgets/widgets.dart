import 'package:flutter/material.dart';

 final textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
     borderSide: const BorderSide(color: Color.fromARGB(255, 77, 222, 69),width: 2),
     borderRadius: BorderRadius.circular(15)
  ),
  enabledBorder: OutlineInputBorder(
     borderSide: const BorderSide(color: Colors.grey,width: 2),
     borderRadius: BorderRadius.circular(15)
  ),
  errorBorder: OutlineInputBorder(
     borderSide: const BorderSide(color: Colors.redAccent,width: 2),
     borderRadius: BorderRadius.circular(15)
  ),

);


  void nextScreen(context, page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
  }
  
  void nextScreenReplace(context, page){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));
  }
