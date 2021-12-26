import 'package:flutter/material.dart';

class UserTodo{
  final String? id;
  final DateTime? expiryDate;
  final String? title;
  final TimeOfDay? expiryTime;
  final int? importance;
  UserTodo({this.id,this.expiryDate,this.title,this.importance,this.expiryTime});
}
class TodoProvider with ChangeNotifier{
   List<UserTodo>_works= [
    UserTodo(id: "1",expiryDate: DateTime.now(),expiryTime: TimeOfDay.now(),title: "Coding",importance: 200),

  ];
   List<UserTodo> get getWorks{
     return [..._works];
   }
   UserTodo? getTodo(String id){
     int index=_works.indexWhere((todo)=> todo.id==id);
    if(index==-1)return null;
    return _works[index];
   }
   void addWork(String id,String title,int importance,DateTime expiryDate,TimeOfDay expiryTime){
    UserTodo todo=UserTodo(
        id: id,
      importance: importance,
        title: title,
      expiryDate: expiryDate,
      expiryTime: expiryTime
    );
     _works.add(todo);
     notifyListeners();
  }
  void updateWork(String id,String title,int importance,DateTime expiryDate,TimeOfDay expiryTime){

  }
  void deleteWork(String ? _todoId){
    _works.removeWhere((todo) => todo.id == _todoId);
    notifyListeners();
    return ;
  }
}