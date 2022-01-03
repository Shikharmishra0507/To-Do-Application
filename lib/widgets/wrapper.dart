import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/screens/authentication.dart';
import 'package:todo/screens/todo_list.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Provider.of<User?>(context)==null  ? AuthScreen() : TodoList();
  }
}
