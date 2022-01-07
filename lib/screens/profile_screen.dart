import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String route='/profile';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Container(color: Colors.black,),
        Positioned(
          top: MediaQuery.of(context).size.height*0.2,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.8,
          child: Container(

            color:Colors.blue),),
        Positioned(

          right: MediaQuery.of(context).size.width*0.4,
            top: MediaQuery.of(context).size.height*0.15,
            height: 200,
            width: 200,
            child: CircleAvatar(
          child: Icon(Icons.supervised_user_circle),)
        )
    ],);
  }
}
