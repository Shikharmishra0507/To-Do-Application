import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_new_task.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:provider/provider.dart';
class TaskCard extends StatelessWidget {
  final UserTodo _todo;
  TaskCard(this._todo);
  @override
  Widget build(BuildContext context) {
    Future<void> showAddTaskSheet() async{
      await showModalBottomSheet(context: context, builder: (context){
        return AddNewTask(_todo);
      });
    }
    return Card(
      elevation: 2,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         Expanded(child: CircleAvatar(backgroundColor: Colors.red[_todo.importance!],)),
          Expanded(
            flex: 5,
              child:Text(_todo.title!)),
         Expanded(child: Row(children: [
           IconButton(onPressed: (){
             showAddTaskSheet();
           }, icon: Icon(Icons.edit)),
           IconButton(onPressed: (){
             Provider.of<TodoProvider>(context,listen: false).deleteWork(_todo.id);
           }, icon: Icon(Icons.delete))
         ],),)

      ],)
    );
  }
}
