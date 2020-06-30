import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:mydstv_gotv_self_service/data/data.dart';
import 'package:mydstv_gotv_self_service/models/activities.dart';
import 'package:mydstv_gotv_self_service/models/fcm_model.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/clear_error.dart';
import 'package:mydstv_gotv_self_service/screens/fcm_messaging.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/prod.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/screens/purchase_items.dart';
import 'package:mydstv_gotv_self_service/screens/request_installation.dart';
import 'package:mydstv_gotv_self_service/screens/subscribe_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/fcm.dart';
import 'package:mydstv_gotv_self_service/widgets/fcm_widget.dart';
import 'package:mydstv_gotv_self_service/widgets/messaging.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/hello.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:mydstv_gotv_self_service/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'activity_screen.dart';

class HomeScreen extends StatefulWidget
{
  final String userId;

  HomeScreen({this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{

  DateTime _date = DateTime.now();
  String _selected;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy').add_jm();
  String _userId;
  List<FcmModel>_messages;
  List<FcmModel> _mainMessage;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();

    _dateFormatter.format(_date);
    _userId = widget.userId;
//    print("home: "+ widget.userId);

    _getToken();
    _configureListeners();
    _messages = List<FcmModel>();

    Provider.of<AuthService>(context, listen: false).updateToken();
    _userId = Provider.of<UserData>(context, listen: false).currentUserId;


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
         Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(builder: (context) => LoginScreen()),
               (Route<dynamic> route) => false,
         );
      }

    });

  }

  _getToken()async{
    _firebaseMessaging.getToken().then((deviceToken)
    {

    });
  }

  _configureListeners()async
  {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message)async
        {

          _setMessages(message);
        },
        onLaunch: (Map<String, dynamic> message)async
        {
          _setMessages(message);
        },
        onResume: (Map<String, dynamic> message)async
        {

          _setMessages(message);
        },

    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            badge: true,
            alert: true
        )
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((settings)
    {

    });
  }
  _setMessages(Map<String, dynamic> message)async
  {
    final notification = message['notification'];
    final data = message['data'];

    final String title = notification['title'];
    final String body = notification['body'];

    final String mMessage = data['message'];


    setState(()
    {
       FcmModel m = FcmModel(title: title, body: body, message: mMessage);
      _messages.add(m);
      _mainMessage = _messages;

    });



  }

  _buildActivities()
  {
    List<Widget> activityList = [];
    activities.forEach((Activity activity){
      activityList.add(
          GestureDetector(
            onTap: ()=>Navigator.push(context,
                MaterialPageRoute(
                  builder: (_)
                  {
                    if(activity.name == "Purchase"){
                      return ProdScreen();
                    }
                    else if(activity.name == "Subscribe")
                    {
                      return Subscribe();
                    }
                    else if(activity.name == "Clear Error Code")
                    {
                      return ClearError();
                    }
                    else if(activity.name == "Request Service")
                    {
                      return RequestInstallation();
                    }
                    else
                      {
                      return HomeScreen();
                    }
                  },
                )),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey[200],
                  )
              ),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      height: 150.0,
                      width: 150.0,
                      image: AssetImage(activity.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(activity.name, style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          ),

                          SizedBox(height: 6.0),
                          Text(activity.address, style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,

                          ),
                            softWrap: true,
                            maxLines: 2,
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    });
    return Column(
        children: activityList);

  }
  @override
  Widget build(BuildContext context)
  {

    final currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;




    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Center(child:
          Text('MyDStv GOtv Self Support', style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),)),
        ),

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
        body: ListView(
          children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),

        ),

          _mainMessage != null ? Fcm(list: _mainMessage) : SizedBox.shrink(),
            SizedBox(height: 5.0),
        Welcome(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:EdgeInsets.symmetric(horizontal: 1.0),
              child: Center(
                child: Text('Our Packages', style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
                ),
              ),
            ),
            _buildActivities(),
            SizedBox(height: 20.0),
          ],
        ),
            SizedBox(height: 20.0),

        ],
     ),
    );

  }
}

