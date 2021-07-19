import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}
class _AuthenticationState extends State<Authentication> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance
        .userChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return _authDisplay('All good');
  }

  _authDisplay(String text){
    return Center(
      child: Text(text),
    );
  }
}
