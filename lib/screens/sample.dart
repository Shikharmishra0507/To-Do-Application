import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/widgets/task_card.dart';
import '../services/database.dart';
import '../models/user_model.dart';
class Sample extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final data=Provider.of<UserModel?>(context);
    
    return data==null || data.todos==null ? Container(child:Text("NO Task")) : Container(
      child:ListView.builder(
        itemBuilder: (BuildContext context,int index)=>TaskCard( data.todos![index]),
        itemCount: data.todos!.length,
      )
    );
  }
}
