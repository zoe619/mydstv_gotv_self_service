import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/screens/bouquet.dart';
import 'package:mydstv_gotv_self_service/screens/channel.dart';
import 'package:mydstv_gotv_self_service/screens/clear_error.dart';
import 'package:mydstv_gotv_self_service/screens/home_screen.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/purchase_items.dart';
import 'package:mydstv_gotv_self_service/screens/request_installation.dart';
import 'package:mydstv_gotv_self_service/screens/subscribe_screen.dart';
import 'package:mydstv_gotv_self_service/screens/trans.dart';
import 'package:mydstv_gotv_self_service/screens/transaction_history.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatelessWidget
{

  _dialPhone() async
  {

    String phone = "08099926467";

    String number = "tel:"+phone;
    launch(number);
    if (await canLaunch(number))
    {
      await launch(number);
    }
    else{

      phone = "09081867279";
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
    List<String> recipients = ["09081867279", "08099926467"];


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
                  'MyDStv GOtv Self Support',
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
            title: Text('Transaction History'),
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
            title: Text('Call Customer Care'),
            onTap: () => _dialPhone(),
          ),

          ListTile(
            leading: Icon(Icons.message),
            title: Text('Message Customer Care'),
            onTap: () =>_sendSMS(),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),

        ],
      ),
    );
  }
}