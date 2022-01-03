import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewTask extends StatefulWidget {

  UserTodo? _todo;
  AddNewTask(this._todo);
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {

  bool isInit=false;
  final TextEditingController _titleController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int ?_selectedImportance=100;
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();
  var uuid = Uuid();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(!isInit && widget._todo!=null){
      isInit=true;
      _selectedImportance=widget._todo!.importance;
      _selectedTime=widget._todo!.expiryTime;
      _selectedDate=widget._todo!.expiryDate;
      _titleController.text=widget._todo!.title!;
    }
    super.didChangeDependencies();
  }
  Future<void> _showInputDate(BuildContext context) async {
    DateTime? date   = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100, 1));
    if (date != null && date != _selectedDate) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _showInputTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (time != null && time != _selectedTime) {
      setState(() {
        _selectedTime = time;

      });
    }
  }
  Future<void> showErrorDialog(String message,BuildContext context) async{
    await showDialog<void>(context: context, builder: (context) {
      return AlertDialog(
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();
          },child:Text("Okay!!"))
        ],
        title: Text(message),
      );
    },);
  }
  Future<void> _saveUserData(BuildContext ctx) async{
    if(!_formKey.currentState!.validate())return ;
    if( _selectedImportance==null || _selectedDate==null || _selectedTime==null)return ;

    try {
      if(widget._todo==null){
        await Provider.of<TodoProvider>(context,listen:false).
        addWork(uuid.v4(),_titleController.text , _selectedImportance!,_selectedDate!,_selectedTime!);
      }
      else{
        await Provider.of<TodoProvider>(context,listen:false).
        updateWork(widget._todo!.id,_titleController.text , _selectedImportance!,_selectedDate!,_selectedTime!);
      }
    } on Exception catch (e) {
      // TODO
    }
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
            key: _formKey,
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
                      child:widget._todo!=null ?Text("Edit Your Task", style: TextStyle(fontSize: 18))  : Text("Add a New Task", style: TextStyle(fontSize: 18))),
                ),
                Flexible(
                  fit:FlexFit.loose,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(

                        decoration: InputDecoration(hintText: "Enter You Task",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                          prefixIcon: Icon(Icons.work)
                        ),
                        controller: _titleController,
                        validator: (String ?val){
                          if(val==null || val.length==0)return "Enter a Name For Your Task";
                          return null;
                        },
                      ),

                      Slider(
                        value: (_selectedImportance ?? 100).toDouble(),
                        min:100.0,
                        max:800.0,
                        onChanged: (double ?imp){
                          if(imp!=null && imp!=_selectedImportance){
                            setState(() {
                              _selectedImportance=imp.round();
                            });
                          }
                        },
                        activeColor: _selectedImportance ==null? Colors.red[100]: Colors.red[_selectedImportance!],

                        inactiveColor: _selectedImportance ==null? Colors.red[100]: Colors.red[_selectedImportance!],
                        divisions: 7,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Complete this task before this Date"),
                          TextButton(
                              child: Text(
                                  DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                              onPressed: () async {
                                await _showInputDate(context);
                              }),
                          Text("And before this time"),
                          TextButton(
                              child: _selectedTime == null
                                  ? Text(
                                      "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}")
                                  : Text(
                                      "${_selectedTime!.hour} : ${_selectedTime!.minute}"),
                              onPressed: () async {
                                await _showInputTime(context);
                              })
                        ],
                      )
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: ElevatedButton(
                      onPressed: () {
                        //on submit validate then push data into firestore and then pop
                        _saveUserData(context);

                      },
                      child: Text("Submit")),
                )
              ],
            )),

    );
  }
}
