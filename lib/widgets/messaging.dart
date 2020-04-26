//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_sms/flutter_sms.dart';
//import 'package:mydstv_gotv_self_service/models/message.dart';
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
//class Messaging extends StatefulWidget
//{
//  @override
//  _MessagingState createState() => _MessagingState();
//}
//
//class _MessagingState extends State<Messaging>
//{
//
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//  final List<Message> _message = [];
//  String _selected;
//  String _userId;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async
//      {
//        print("Onmessage: $message");
//        final notifications = message['notification'];
//        setState(() {
//          _message.add(Message(
//            title: notifications['title'], body: notifications['body']
//          ));
//        });
//      },
//
//      onLaunch: (Map<String, dynamic> message)async
//      {
//        print("Onlaunch: $message");
//        final notifications = message['data'];
//        setState(() {
//          _message.add(Message(
//              title: notifications['title'], body: notifications['body']
//          ));
//        });
//      },
//      onResume: (Map<String, dynamic>message)async
//      {
//        print("Onresume: $message");
//      }
//
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//      const IosNotificationSettings(sound: true, badge: true, alert: true),
//    );
//
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
//  @override
//  Widget build(BuildContext context)
//  {
//     return Scaffold(
//         drawer: NavDrawer(),
//         appBar: AppBar(
//           title: Center(child:
//           Text('Migrand message', style: TextStyle(
//             color: Colors.white,
//             fontSize: 32.0,
//           ),
//           )),
//
//           actions: <Widget>[
//
//             new PopupMenuButton(
//               itemBuilder: (BuildContext context){
//                 return PopUp.pop.map((PopUp pop){
//                   return new PopupMenuItem(
//                     value: pop,
//
//                     child: new ListTile(
//                       title: pop.title,
//                       leading: pop.icon,
//                     ),
//
//                   );
//
//                 }).toList();
//               },
//               onSelected: choiceAction,
//             ),
//           ],
//
//     ),
//       body: ListView(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(20.0),
//
//           ),
//           Welcome(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding:EdgeInsets.symmetric(horizontal: 1.0),
//                 child: Center(
//                   child: Text('Notifications', style: TextStyle(
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1.2,
//                   ),
//                   ),
//                 ),
//               ),
//
//             ],
//
//           ),
//           SizedBox(height: 10.0),
//           message(),
//         ],
//
//       ),
//     );
//
//  }
//
//  Widget message()
//  {
//    return ListView(
//      children: _message.map(_buildMessage).toList(),
//    );
//
//  }
//  Widget _buildMessage(Message message){
//    return SingleChildScrollView(
//      child: ListTile(
//         title: Text(message.title),
//         subtitle: Text(message.body),
//      ),
//    );
//  }
//}
