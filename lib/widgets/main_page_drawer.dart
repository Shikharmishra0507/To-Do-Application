import 'package:flutter/material.dart';
class MainPageDrawer extends StatelessWidget {
  const MainPageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Column(children: [
      ListTile(title: Text("Main Page"),),
      ListTile(title: Text("Task Done"),),
      ListTile(title: Text("Task Need to be done"),)
    ],),);
  }
}
