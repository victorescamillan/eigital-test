import 'package:eigital_test/constants/app_labels.dart';
import 'package:eigital_test/views/main_tab_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController(text: 'victor@gmail.com');
  TextEditingController _passwordController = TextEditingController(text: '123456');
  String _error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLabels.appName, style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
              border: OutlineInputBorder(),
                hintText: AppLabels.email
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppLabels.password,
              ),
            ),
            SizedBox(height: 20,),
            Text('$_error', style: TextStyle(color: Colors.redAccent),),
            SizedBox(height: 20,),

            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              child: ElevatedButton(onPressed: () async {
                print('Email ${_emailController.text}');
                await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
                    .then((value) {
                      Navigator.pushReplacement(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => MainTabPage(),
                      ),);
                    })
                    .catchError((error) {
                      setState(() {
                        _error = error.toString();
                      });
                });
              },
                child: Text(AppLabels.login),
                style: ButtonStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
