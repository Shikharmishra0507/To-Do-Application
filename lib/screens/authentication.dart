
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/services/auth_services.dart';
import 'package:provider/provider.dart';


class AuthScreen extends StatefulWidget {
  //const AuthScreen({Key? key}) : super(key: key);
  static const String route = "/AuthScreen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum Auth { SignUp, Login }

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  bool _passwordVisible=false;
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Auth _auth = Auth.Login;

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void showErrorDialog(String message,BuildContext context){
    showDialog<void>(
      context: context,
      // barrierDismissible: barrierDismissible,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Error Occurred in authentication'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Okay!!"),
              onPressed: () {
                Navigator.of(ctx).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
  final _authService=AuthServices();
  Future<void> _saveForm(BuildContext context) async {

    if (!_formKey.currentState!.validate()) return;


    _formKey.currentState!.save();

    if(mounted){
      setState((){
        isLoading=true;
      });
    }


    try {
      if(_auth==Auth.Login){

        final _user=await _authService.signIn(_emailController.text, _passwordController.text);
      }
      else {
        final _user= await _authService.signUp(_emailController.text,_passwordController.text);

      }
    }  catch (e) {

      showErrorDialog(e.toString(),context);
    }
    if(mounted){
      setState(() {
        isLoading=false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(),
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: [
          Container(),
          Center(
              child: Container(
                  width: size.width * 0.5,
                  height: _auth == Auth.Login
                      ? size.height * 0.5
                      : size.height * 0.6,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Text("Email",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator: (String? value) {
                                if (value == null || value.length == 0)
                                  return "Email cannot be null";
                                if (!(value.contains("@")) ||
                                    !value.contains(".com"))
                                  return "Invalid Email";
                                return null;
                              },
                              controller: _emailController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: "Email"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("Password",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            TextFormField(
                              obscureText: !_passwordVisible,

                              validator: (String? value) {
                                if (value == null || value.length <= 8) {
                                  return "Very Few Characters";
                                }
                                return null;
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.password),
                                  suffixIcon:IconButton(icon:
                                  _passwordVisible ?Icon(Icons.visibility_off) :Icon(Icons.visibility),
                                      onPressed:(){
                                    if(mounted){
                                      setState((){
                                        _passwordVisible=!_passwordVisible;
                                      });
                                    }

                                      }),
                                  hintText: "Password"),
                            ),
                          ],
                        ),
                        if (_auth == Auth.SignUp)
                          TextFormField(
                              obscureText: true,
                              validator: (String? value) {
                                if (value!.compareTo(
                                    _passwordController.text) !=
                                    0) return "Passwords do not match";
                                return null;
                              },
                              decoration:const InputDecoration(
                                  hintText: "ConfirmPassword",
                                  prefixIcon: Icon(Icons.password))),
                        Center(
                          child: Container(
                            width: size.width * 0.23,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(
                                      Colors.amber),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(38.0),
                                      ))),
                              child: _auth == Auth.Login
                                  ? Text("Login")
                                  : Text("SignUp"),
                              onPressed: () =>_saveForm(context),
                            ),
                          ),
                        ),
                        Row(children: [
                          _auth == Auth.Login
                              ? const Text("Don't Have an Account ? Sign In")
                              : Text("Already Registered ? Login"),
                          TextButton(
                              onPressed: () {
                                if(mounted){
                                  setState(() {
                                    if (_auth == Auth.Login) {
                                      _auth = Auth.SignUp;
                                    } else {
                                      _auth = Auth.Login;
                                    }
                                  });
                                }

                              },
                              child: Text("Here"))
                        ])
                      ],
                    ),
                  )))
        ]));
  }
}