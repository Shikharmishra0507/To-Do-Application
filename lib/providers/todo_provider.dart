import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database.dart';
class UserTodo {
  final String? id;
  final DateTime? expiryDate;
  final String? title;
  final TimeOfDay? expiryTime;
  final int? importance;

  UserTodo(
      {this.id, this.expiryDate, this.title, this.importance, this.expiryTime});

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Map<String, dynamic> toJson(UserTodo todo) {
    return {
      'id': todo.id,
      'expiryDate': todo.expiryDate.toString(),
      'expiryTime': formatTimeOfDay(todo.expiryTime!),
      'title': todo.title,
      'importance': todo.importance,
    };
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"

    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  factory UserTodo.fromJson(Map<String, dynamic> json) {
    return UserTodo(
        id: json['id'],
        expiryDate: DateTime.parse(json['expiryDate']),
        importance: json['importance'],
        title: json['title'],
        expiryTime: stringToTimeOfDay(json['expiryTime']));
  }
}

class TodoProvider with ChangeNotifier {
  static List<UserTodo> works = [

  ];

    List<UserTodo> get getWorks {
    return [...works];
  }

  UserTodo? getTodo(String id) {
    int index = works.indexWhere((todo) => todo.id == id);
    if (index == -1) return null;
    return works[index];
  }

  Future<void> addWork(String id, String title, int importance, DateTime expiryDate,
      TimeOfDay expiryTime) async{

    UserTodo todo = UserTodo(
        id: id,
        importance: importance,
        title: title,
        expiryDate: expiryDate,
        expiryTime: expiryTime);
    List<UserTodo>copy=[];
    for (var element in works) { copy.add(element);}
    works.add(todo);
    try {
      await Database().updateUserTodo();
    } on Exception catch (e) {
      // TODO
      works=copy;
      print(e);
    }
    notifyListeners();
  }
  Future<void> getWorksFromFirebase ()async{
      await Database().getTodoFromFirebase();
      notifyListeners();
  }
  Future<void> updateWork(String? id, String title, int importance, DateTime expiryDate,
      TimeOfDay expiryTime) async{
      int index= works.indexWhere((todos) => todos.id == id);
      if(index==-1)return ;
      works[index]=UserTodo(id: id,title: title,importance: importance,expiryDate: expiryDate,expiryTime: expiryTime);
      try {
        await Database().updateUserTodo();
      } on Exception catch (e) {
        // TODO

        rethrow;
      }
    notifyListeners();
  }

  void deleteWork(String? _todoId) {
    works.removeWhere((todo) => todo.id == _todoId);
    notifyListeners();
    return;
  }
}
