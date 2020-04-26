import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/channel.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:mydstv_gotv_self_service/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Channel extends StatefulWidget
{
  @override
  _ChannelState createState() => _ChannelState();

  final String package;

  Channel({this.package});
}

class _ChannelState extends State<Channel>
{
  String _selected;
  String _userId;


  List<Channels> _channel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userId = Provider.of<UserData>(context, listen: false).currentUserId;

  }

  _getChannel() async{
    List<Channels> channel = await Provider.of<DatabaseService>(context, listen: false).getChannel2(widget.package);
    if(mounted){
      setState(() {
        _channel = channel;

      });
    }

  }

  _dialPhone() async
  {

    String phone = "08033169636";

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

//    String phone = "08033169636";
    String message = "type a message";
    List<String> recipients = ["08033169636", "08099926467"];

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

      if(_selected == 'profile')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(currentUserId: _userId),
        ));


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
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>LoginScreen(),
        ));
      }

    });

  }

  SingleChildScrollView _dataBody()
  {


    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [

            DataColumn(
              label: Text("S/N"),
            ),
            DataColumn(
              label: Text("BRAND"),
            ),
            DataColumn(
              label: Text("PACKAGE"),
            ),
            DataColumn(
              label: Text("CHANNEL"),
            ),
            DataColumn(
              label: Text("CHANNEL NUMBER"),
            ),

          ],

          rows: _channel.map((chan)=>DataRow(

              cells: [

                DataCell(Text(chan.id.toString())),
                DataCell(Text(chan.brand.toUpperCase())),
                DataCell(Text(chan.package.toUpperCase())),
                DataCell(Text(chan.channel.toUpperCase())),
                DataCell(Text(chan.channel_number)),

              ]

          )

          ).toList(),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child:
        Text('Channels list', style: TextStyle(
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
          future: _getChannel(),
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {


            return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Welcome(),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text('Channels list', style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                        ),
                      ),
                    ),
                    Expanded(child:
                    _channel != null ? _dataBody() : Center(child:
                    Platform.isIOS
                        ? new CupertinoActivityIndicator() :
                    CircularProgressIndicator()),
                    ),
                  ],
                )

            );
          }

      ),
    );
  }
}
