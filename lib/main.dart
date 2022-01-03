import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/profile_screen.dart';
import '/widgets//wrapper.dart';
import 'package:todo/screens/authentication.dart';
import 'package:todo/screens/todo_list.dart';

import 'package:todo/services/auth_services.dart';
import '/providers/todo_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers:[
        ChangeNotifierProvider(
            create: (_)=>TodoProvider()),
        ChangeNotifierProvider(create: (_)=>AuthServices()),

        StreamProvider.value(
          initialData:null,
          value: AuthServices().getUser,
        )
      ],
        child: MaterialApp(
             debugShowCheckedModeBanner: false,
             title: 'WHAT TO DO TODAY',
             theme: ThemeData(
               colorScheme:ColorScheme.fromSwatch(accentColor: Colors.purple[00]) ,
               primarySwatch: Colors.deepPurple,
             ),
             home:Wrapper(),
        routes:{
               ProfileScreen.route:(_)=>const ProfileScreen(),
        },

        ),

    );
  }
}

