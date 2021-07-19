import 'package:eigital_test/blocs/map_bloc.dart';
import 'package:eigital_test/blocs/newsfeed_bloc.dart';
import 'package:eigital_test/constants/app_labels.dart';
import 'package:eigital_test/main.dart';
import 'package:eigital_test/views/calculator_page.dart';
import 'package:eigital_test/views/login_page.dart';
import 'package:eigital_test/views/map_page.dart';
import 'package:eigital_test/views/newsfeed_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabPage extends StatefulWidget {
  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLabels.appName),
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => MyApp(),
              ),);
            })
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions)),
              Tab(icon: Icon(Icons.pageview_rounded)),
              Tab(icon: Icon(Icons.calculate)),
            ],
          ),
        ),
      body: TabBarView(
        children: [
          BlocProvider(create: (BuildContext context) => MapBloc(null), child: MapPage(),),
          BlocProvider(create: (BuildContext context) => NewsFeedBloc(), child: NewsfeedPage(),),
          CalculatorPage()
          ],
        )),
    );
  }
}
