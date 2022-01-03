import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database.dart';
class AuthServices with ChangeNotifier{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  Stream<User?> get getUser{
    return _auth.authStateChanges();
  }
  User? get userStatus{
    return _auth.currentUser;
  }
  Future<void>signUp(String email,String password) async{
    try {
      UserCredential credential=
      await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      if(credential.user==null)throw Exception("Authentication Failed");
     await Database().setUserData(credential.user!.uid, null, null, null);
    }  catch (e) {
      rethrow;
    }
    notifyListeners();
  }
  Future<void>signIn(String email,String password) async{
    try {
      UserCredential credential=
      await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      if(credential.user==null)throw Exception("Authentication Failed");
    } on FirebaseAuthException catch (e) {
      rethrow ;
    } catch (e) {
      rethrow;

    }
    notifyListeners();
  }
  Future<void> logOut()async{
   await  _auth.signOut();

  }
}
