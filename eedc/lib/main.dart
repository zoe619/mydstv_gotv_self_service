import 'dart:async';
import 'package:eedc/route/form/form_profile_data.dart';
import 'package:eedc/route/login/login_simple_dark.dart';
import 'package:eedc/route/profile/bills.dart';
import 'package:flutter/material.dart';
import 'data/my_colors.dart';
import 'data/img.dart';
import 'data/shared_pref.dart';
import 'data/sqlite_db.dart';
import 'package:eedc/services/database_helper.dart';

import 'widget/my_text.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: MyColors.primary,
          accentColor: MyColors.accent,
          primaryColorDark: MyColors.primaryDark,
          primaryColorLight: MyColors.primaryLight,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent)
      ),
      home:   SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginSimpleDarkRoute(),
        '/bills': (BuildContext context) => new BillList(),
        '/profile': (BuildContext context) => new FormProfileDataRoute()
      }
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
{

  startTime() async
  {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, navigationPage);
  }

  void navigationPage()
  {
    if(SharedPref.getFcmRegId() != null)
    {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    else{
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.initDb();



//    dbHelper.init();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        child: Container(
          width: 105,
          height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 60, height: 60,
                child:
                Image.asset(Img.get('logo_small_round.png'), color: Colors.grey[800], fit: BoxFit.cover),
              ),
              Container(height: 10),
              Text("EEDC", style: MyText.headline(context).copyWith(
                  color: Colors.grey[800], fontWeight: FontWeight.w600
              )),

              Container(height: 20),
              Container( height: 5, width: 80,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryLight),
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}