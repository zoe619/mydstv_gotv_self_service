import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/edit_profile_screen.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/utilities/constant.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget{
  _ProfileScreenState createState()=> _ProfileScreenState();

  final String currentUserId;


  ProfileScreen({this.currentUserId});


}
class _ProfileScreenState extends State<ProfileScreen>
{


  User _profileUser;
  String _selected;

  @override
  void initState(){
    super.initState();

    _setupProfileUser();
  }
  _dialPhone() async
  {

    String phone = "09081867279";

    String number = "tel:"+phone;
    launch(number);
    if (await canLaunch(number))
    {
      await launch(number);
    }
    else{

      phone = "08099926467";
      String number = "tel:"+phone;
      launch(number);
      if (await canLaunch(number))
      {
        await launch(number);
      }
      else{
        throw 'Could not place a call to $number';
      }
    }

  }

  void _sendSMS() async
  {

//    String phone = "08033169636";https://duo.google.com/
    String message = "type a message";
    List<String> recipients = ["09081867279", "08099926467"];

    String _result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      print(onError);
    });



  }

  void choiceAction(PopUp pop)
  {

    setState(()
    {
      _selected = pop.option;

      if(_selected == 'Profile')
      {
//        Navigator.push(context, MaterialPageRoute(
//          builder: (_)=>ProfileScreen(),
//        ));

      }
      else if(_selected == 'call')
      {
        _dialPhone();
      }
      else if(_selected == 'sms')
      {
        _sendSMS();
      }
      else if(_selected == 'log_out')
      {
        Provider.of<AuthService>(context, listen: false).logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          ModalRoute.withName('/'),
        );
      }

    });

  }


  _setupProfileUser() async
  {
    User profileUser  = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(widget.currentUserId);
    setState(() {
      _profileUser = profileUser;
    });
  }
  _displayButton(User user)
  {
    return user.id == Provider.of<UserData>(context).currentUserId ? Container(
      width: 195.0,
      child: FlatButton(
        color: Colors.grey,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_)=>EditProfileScreen(
              user: user),
        )),
        textColor: Colors.white,
        child: Text('Edit Profile',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    )
        :
    Container(
      width: 195.0,
      child: FlatButton(

        child: Text(
          'Private account',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  _buildProfileInfo(User user)
  {

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 8.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage:
                AssetImage('assets/images/user_placeholder.png')

              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(user.name, style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            ),
                            Text('Name', style: TextStyle(
                              color: Colors.black54,
                            ),
                            )
                          ],
                        ),

                      ],
                    ),
                    _displayButton(user),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user.email,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                  height: 80.0,
                  child: Text(user.phone, style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ),
              Divider(),
            ],
          ),
        ),
      ],
    );

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child:
        Text('Profile', style: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
        ),)),

        actions: <Widget>[

          new PopupMenuButton(
            itemBuilder: (BuildContext context){
              return PopUp.pop.map((PopUp pop){
                return new PopupMenuItem(
                  value: pop,

                  child: new ListTile(
                    title: pop.title,
                    leading: pop.icon,
                  ),

                );

              }).toList();
            },
            onSelected: choiceAction,
          ),
        ],
      ),

      body: FutureBuilder(
        future: usersRef.document(widget.currentUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              _buildProfileInfo(user),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}