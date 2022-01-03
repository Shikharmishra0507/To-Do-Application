import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/providers/todo_provider.dart';
import 'dart:convert' as json;

class Database with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _user = FirebaseAuth.instance;
  Future<void> updateUserTodo() async{
    // update works list
    final todoList = TodoProvider.works.map((todo) {
      return UserTodo().toJson(todo);
    }).toList();
    String _userId=_user.currentUser!.uid;
    DocumentReference docs=firestore.collection('Users').doc(_userId);

    try {
      await docs.update({
        'id': _userId,
        'name': "A New User With New Task",
        'completedTask': 0,
        'incompleteTask': 0,
        'todo': todoList,
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
  Future<void> setUserData(String userId, String? userName, int? completedTask,
      int? incompleteTask) async {
    String userId = _user.currentUser!.uid;
    final todoList = TodoProvider.works.map((todo) {
      return UserTodo().toJson(todo);
    }).toList();

    try {
      final users = await firestore.collection('Users').doc(userId).set({
        'id': userId,
        'name': "A New User",
        'completedTask': 0,
        'incompleteTask': 0,
        'todo': todoList,
      });
    } catch (e) {
      // TODO
      rethrow;
    }
  }
  Future<void> getTodoFromFirebase() async{
    List<UserTodo>todoList=[];
    firestore.collection('Users').doc(_user.currentUser!.uid).snapshots().map((snapshot) {
     if(!snapshot.exists)return ;

     Map<String, dynamic> data = snapshot.data()! ;

     data['todo'].map((todo) {
       Map<String,dynamic>value=Map<String,dynamic>.from(todo);
       final val= UserTodo.fromJson(value);
       todoList.add(val);
     }).toList();
    });
    TodoProvider.works=todoList;
  }
  static UserModel? getUserModel(DocumentSnapshot snapshot) {
    String _userId = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    List<UserTodo>todoList=[];
    data['todo'].map((todo) {
      Map<String,dynamic>value=Map<String,dynamic>.from(todo);
      final val= UserTodo.fromJson(value);
      todoList.add(val);
    }).toList();

    UserModel model = UserModel(
        userId: data['id'],
        name: data['name'],
        completedTask: data['completedTask'],
        incompleteTask: data['incompleteTask'],
        todos: todoList
    );
    return model;
  }

  Stream<UserModel?> getData() {
    return   firestore
        .collection('Users')
        .doc(_user.currentUser!.uid)
        .snapshots().map((snap) => getUserModel(snap));
  }
}
