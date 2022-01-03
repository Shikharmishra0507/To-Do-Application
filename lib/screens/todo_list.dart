import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/user_model.dart';
import '../widgets//add_new_task.dart';
import '../widgets//task_card.dart';
import 'package:todo/services/auth_services.dart';
import '../providers/todo_provider.dart';
import 'package:provider/provider.dart';
import '../widgets//main_page_drawer.dart';
import '../services/database.dart';
import 'sample.dart';
import 'profile_screen.dart';
class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isLoading=false;
  bool isInit=false;
  Future<void> _showInputSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return AddNewTask(null);
      },
    );
  }
@override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    if(!isInit){
      isInit=true;
      await Provider.of<TodoProvider>(context,listen:false).getWorksFromFirebase();
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance;
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: Database().getData(),
      child: Scaffold(
        appBar: AppBar(title: Text("Todo Application"),
        actions: [IconButton(onPressed: ()async{
          await Provider.of<AuthServices>(context,listen:false).logOut();
      }, icon: Icon(Icons.logout)),
          IconButton(icon:Icon(Icons.verified_user),onPressed: (){
            Navigator.of(context).pushNamed(ProfileScreen.route);
          },)
        ],),
        body: Sample(),

        drawer: MainPageDrawer(),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _showInputSheet(context);
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}
