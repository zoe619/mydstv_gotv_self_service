//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_sms/flutter_sms.dart';
//import 'package:mydstv_gotv_self_service/models/user_data.dart';
//import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
//import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
//import 'package:mydstv_gotv_self_service/services/auth_service.dart';
//import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
//import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
//import 'package:mydstv_gotv_self_service/widgets/welcome.dart';
//import 'package:provider/provider.dart';
//import 'package:url_launcher/url_launcher.dart';
//
//
//class FcmMessagingWidget extends StatefulWidget
//{
//  @override
//  _FcmMessagingWidgetState createState() => _FcmMessagingWidgetState();
//}
//
//class _FcmMessagingWidgetState extends State<FcmMessagingWidget>
//{
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  String _selected;
//  String _userId;
//
//  List<Message>_messages;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _getToken();
//    _configureListeners();
//    final currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;
//    setState(() {
//      _userId = currentUserId;
//    });
//    _messages = List<Message>();
//  }
//
//  _dialPhone() async
//  {
//
//    String phone = "08033169636";
//
//    String number = "tel:"+phone;
//    launch(number);
//    if (await canLaunch(number)) {
//      await launch(number);
//    } else {
//      throw 'Could not place a call to $number';
//    }
//
//  }
//
//  void _sendSMS() async
//  {
//
//    String phone = "08033169636";
//    String message = "type a message";
//    List<String> recipients = [phone];
//
//    String _result = await sendSMS(message: message, recipients: recipients)
//        .catchError((onError) {
//      print(onError);
//    });
//
//
//
//  }
//
//  void choiceAction(PopUp pop)
//  {
//
//    setState(()
//    {
//      _selected = pop.option;
//
//      if(_selected == 'profile')
//      {
//        Navigator.push(context, MaterialPageRoute(
//          builder: (_)=>ProfileScreen(currentUserId: _userId),
//        ));
//
//
//      }
//      else if(_selected == 'call')
//      {
//        _dialPhone();
//      }
//      else if(_selected == 'sms')
//      {
//        _sendSMS();
//      }
//      else if(_selected == 'log_out')
//      {
//        Provider.of<AuthService>(context, listen: false).logout();
//        Navigator.push(context, MaterialPageRoute(
//          builder: (_)=>LoginScreen(),
//        ));
//      }
//
//    });
//
//  }
//
//
//  _getToken()async{
//    _firebaseMessaging.getToken().then((deviceToken)
//    {
//      print("divice token $deviceToken");
//    });
//  }
//
//  _configureListeners()async{
//    _firebaseMessaging.configure(
//        onMessage: (Map<String, dynamic> message)async
//        {
//          print('onMessage: $message');
//          _setMessages(message);
//        },
//        onResume: (Map<String, dynamic> message)async
//        {
//          print('onResume: $message');
//          _setMessages(message);
//        },
//        onLaunch:(Map<String, dynamic> message)async
//        {
//          print('onLaunch: $message');
//          _setMessages(message);
//        }
//    );
//  }
//  _setMessages(Map<String, dynamic> message)async
//  {
//    final notification = message['notification'];
//    final data = message['data'];
//
//    final String title = notification['title'];
//    final String body = notification['body'];
//
//    final String mMessage = data['message'];
//
//
//    setState(()
//    {
//      Message m = Message(title: title, body: body, message: mMessage);
//      _messages.add(m);
//
//    });
//
//
//
//  }
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return Scaffold(
//        drawer: NavDrawer(),
//        appBar: AppBar(
//          title: Padding(
//            padding: const EdgeInsets.only(right: 10.0),
//            child: Center(child:
//            Text('mydstv gotv self_service', style: TextStyle(
//              color: Colors.white,
//              fontSize: 20.0,
//            ),)),
//          ),
//
//          actions: <Widget>[
//
//            new PopupMenuButton(
//              itemBuilder: (BuildContext context){
//                return PopUp.pop.map((PopUp pop){
//                  return new PopupMenuItem(
//                    value: pop,
//
//                    child: new ListTile(
//                      title: pop.title,
//                      leading: pop.icon,
//                    ),
//
//                  );
//
//                }).toList();
//              },
//              onSelected: choiceAction,
//            ),
//          ],
//
//        ),
//        body: ListView.builder(
//          itemCount: null == _messages ? 0 :_messages.length,
//          itemBuilder: (context, int index){
//            return Card(
//              child: Padding(
//                padding: EdgeInsets.all(15.0),
//                child: Text(
//                  _messages[index].message,
//                  style: TextStyle(
//                      fontSize: 16.0,
//                      color: Colors.black
//                  ),
//                ),
//              ),
//            );
//          },
//        )
//    );
//  }
//}
//
//class Message
//{
//  String title, body, message;
//
//
//  Message({this.title, this.body, this.message});
//
//
//}
