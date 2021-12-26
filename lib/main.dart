import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/todo_list.dart';
import '/providers/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>TodoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme:ColorScheme.fromSwatch(accentColor: Colors.purple[00]) ,
          primarySwatch: Colors.deepPurple,
        ),
        home: Container(
          child:TodoList()
        ),
      ),
    );
  }
}

