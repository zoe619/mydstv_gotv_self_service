import 'dart:io';
import 'package:doc_call/screens/get_prescription.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/new_user.dart';
import 'package:doc_call/screens/register.dart';
import 'package:doc_call/screens/user_code.dart';
import 'package:doc_call/screens/user_details.dart';
import 'package:doc_call/screens/view_prescription.dart';
import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_data.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_)=>UserData(),
      ),
      Provider<DatabaseService> (
        create: (_) => DatabaseService(),
      ),



    ],
    child:  MyApp(),
  ),

);
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'doc_on_call',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,

        ),
        home: LoginPage(),

        routes: {
          'dashboard': (context) => HomeScreen(),
          'login_page': (context) => LoginPage(),
          'user_details': (context) => UserDetails(),
          'user_code': (context) => UserCode(),
          'get_prescription': (context) =>GetPrescription(),
          'view_prescription': (context) =>ViewPrescription(),
          'new_user': (context) =>NewUser(),
          'register': (context) =>Register(),
        }

        );

  }
}

