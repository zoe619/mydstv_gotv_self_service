import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/screens/bouquet.dart';
import 'package:mydstv_gotv_self_service/screens/channel.dart';
import 'package:mydstv_gotv_self_service/screens/clear_error.dart';
import 'package:mydstv_gotv_self_service/screens/home_screen.dart';
import 'package:mydstv_gotv_self_service/screens/purchase_items.dart';
import 'package:mydstv_gotv_self_service/screens/request_installation.dart';
import 'package:mydstv_gotv_self_service/screens/subscribe_screen.dart';
import 'package:mydstv_gotv_self_service/screens/trans.dart';
import 'package:mydstv_gotv_self_service/screens/transaction_history.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatelessWidget
{

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
            child: DrawerHeader(
              child: Center(

                child: Text(
                  'mydstv gotv self_support',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),

            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>HomeScreen(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.subject),
            title: Text('Subscribe'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>Subscribe(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Purchase'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>PurchaseItems(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.cast_connected),
            title: Text('Request Service'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>RequestInstallation(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.error),
            title: Text('Clear Error Codes'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>ClearError(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Transaction history'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>Trans(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Channels List'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>Bouquet(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('Call customer care'),
            onTap: () => _dialPhone(),
          ),

          ListTile(
            leading: Icon(Icons.message),
            title: Text('Message customer care'),
            onTap: () =>_sendSMS(),
          ),

        ],
      ),
    );
  }
}