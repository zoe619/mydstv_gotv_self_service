import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/transaction.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
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


class Transaction extends StatefulWidget
{
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction>
{

  User userData;
  String _selected;
  String _userId;
  String _email;
  List<Transactions> _transaction;
  int len;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
    getUserData();
    _getTransaction();


  }

  getUserData() async{
    User user = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(_userId);

    setState(() {
      userData = user;
      _email = userData.email;
    });

  }

  _getTransaction() async{
    List<Transactions> transaction = await Provider.of<DatabaseService>(context, listen: false).getTransaction(_email);
    setState(() {
      _transaction = transaction;


    });

  }

  _dialPhone() async
  {

    String phone = "08033169636";

    String number = "tel:"+phone;
    launch(number);
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not place a call to $number';
    }

  }

  void _sendSMS() async
  {

    String phone = "08033169636";
    String message = "type a message";
    List<String> recipients = [phone];

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

  _showErrorDialog(String errMessage, String status)
  {
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text(status),
            content: Text(errMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              )
            ],
          );
        }
    );

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
              label: Text("ID"),
            ),
            DataColumn(
              label: Text("EMAIL"),
            ),
            DataColumn(
              label: Text("AMOUNT"),
            ),
            DataColumn(
              label: Text("PERIOD"),
            ),
            DataColumn(
              label: Text("STATUS"),
            ),
            DataColumn(
              label: Text("TYPE"),
            )
          ],
          rows: _transaction.map((trans)=>DataRow(
               cells: [
                 DataCell(Text(trans.id)),
                 DataCell(Text(trans.email.toUpperCase())),
                 DataCell(Text(trans.amount.toUpperCase())),
                 DataCell(Text(trans.period.toUpperCase())),
                 DataCell(Text(trans.status.toUpperCase())),
                 DataCell(Text(trans.type.toUpperCase()))
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
        Text('Transactions', style: TextStyle(
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
          future: _getTransaction(),
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {

            if(_transaction == null)
            {
              _showErrorDialog("No transactions yet", "error");
            }
              return Container(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Welcome(),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text('Your Transactions', style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                          ),
                        ),
                      ),
                      Expanded(child:
                       _transaction != null ? _dataBody() : Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
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
