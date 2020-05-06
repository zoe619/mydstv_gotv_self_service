import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydstv_gotv_self_service/screens/home_screen.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/purchase_items.dart';
import 'package:mydstv_gotv_self_service/screens/subscribe_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
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
        Provider<AuthService> (
          create: (_) => AuthService(),
        ),



      ],
      child:  MyApp(),
    )


);

class MyApp extends StatelessWidget
{



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {

    return MaterialApp(
      title: 'mydst gotv self support',
      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        primaryColor: Colors.blue,
//      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[50],
        primaryColor: Colors.blue[900],
        primarySwatch: Colors.blue,
      ),
//      stream to check if user is logged in or not
      home: StreamBuilder<FirebaseUser>(
        stream: Provider.of<AuthService>(context, listen: false).user,
        builder: (BuildContext context, AsyncSnapshot snapshot)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            Center(
              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData)
          {
            Provider.of<UserData>(context, listen: false).currentUserId
            = snapshot.data.uid;
            return HomeScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId);
          }
          else
            {
            return LoginScreen();
          }

        },

      ),
        routes: <String,WidgetBuilder>{
          "/homePage":(BuildContext context)=> new HomeScreen(),
          "/subPage":(BuildContext context)=> new Subscribe(),
          "/purchasePage":(BuildContext context)=> new PurchaseItems(),
        }
    );
  }
}

