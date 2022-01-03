import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String route='/profile';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Container(color: Colors.black,),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height*0.75,

              color:Colors.blue),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: CircleAvatar(
            child: ColoredBox(color: Colors.black,),
          ),
        )
    ],);
  }
}
