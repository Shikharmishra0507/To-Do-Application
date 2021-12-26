import 'package:flutter/material.dart';
import 'package:todo/model/add_new_task.dart';
import 'package:todo/model/task_card.dart';
import '../providers/todo_provider.dart';
import 'package:provider/provider.dart';
import '../model/main_page_drawer.dart';


class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  Future<void> _showInputSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return AddNewTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<UserTodo> _works = Provider.of<TodoProvider>(context).getWorks;
    return Scaffold(
      appBar: AppBar(title: Text("Todo Application")),
      body: Container(
        width:MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: _works.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                child: TaskCard(_works[index]));
          },
        ),
      ),
      drawer: MainPageDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showInputSheet(context);
          },
          child: Icon(Icons.add)),
    );
  }
}
