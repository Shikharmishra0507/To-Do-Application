import 'package:flutter/cupertino.dart';

import '../providers/todo_provider.dart';

class UserModel {
  final String? userId;
  final String? name;
  final int? completedTask;
  final int? incompleteTask;
  final List<UserTodo>? todos;

  UserModel(
      {this.userId,
      this.name,
      this.completedTask,
      this.incompleteTask,
      this.todos});
}

class UserDataProvider with ChangeNotifier {
  //local provider of name ,complete and incomlete task
  // we will be using them in database to update the user info if one variable changes
  // UserModel _user=UserModel();
  // UserMode
  Future<void> updateName() async {}

  Future<void> updateCompletedTask() async {}
  Future<void> updateIncompleteTask()async{}
}
