import 'package:eigital_test/constants/app_labels.dart';
import 'package:eigital_test/views/login_page.dart';
import 'package:eigital_test/views/main_tab_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLabels.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print('error $snapshot');
            return Center(
              child: Text('Something wrong'),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            var currentUser = FirebaseAuth.instance.currentUser;
            return currentUser != null ? MainTabPage() : LoginPage();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}


