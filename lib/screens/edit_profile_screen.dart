import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfileScreen extends StatefulWidget {
  _EditProfileScreenState createState() => _EditProfileScreenState();

  final User user;
  EditProfileScreen({this.user});

}
class _EditProfileScreenState extends State<EditProfileScreen>
{

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _phone = '';
  String _name = '';



  bool _isLoading = false;
  @override
  void initState()
  {
    super.initState();
    _phone = widget.user.phone;
    _name = widget.user.name;


  }
  String _selected;

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

//    String phone = "08033169636";
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
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(currentUserId: widget.user.id),
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


  _displayProfileImage()
  {

    return AssetImage('assets/images/user_placeholder.png');
  }

  _showErrorDialog(String errMessage)
  {
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text('Response'),
            content: Text(errMessage),
            actions: <Widget>[
              Platform.isIOS
                  ? new CupertinoButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              ) : FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              )
            ],
          );
        }
    );

  }
  _submit() async
  {

    setState(()=> _isLoading = false);
    if(!_formKey.currentState.validate()){
      SizedBox.shrink();
    }
    else if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 60),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
            action: new SnackBarAction(
                label: 'OK',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));

    }
    try
    {
      if(_formKey.currentState.validate() && !_isLoading)
      {
        _formKey.currentState.save();


        final dbService = Provider.of<DatabaseService>(context, listen: false);
//        update user info in mysql server database
        List res = await dbService.updateUser(widget.user.email, _phone, _name);
        Map<String, dynamic> map;
        for(int i = 0; i < res.length; i++)
        {
          map = res[i];

        }

        if(map['status'] == "fail")
        {
          _showErrorDialog(map['msg']);
        }
        else
        {

          // update user in firebase
          User user = User(
            id: widget.user.id,
            phone: _phone,
            name: _name
          );

          DatabaseService.updateUserFirebase(user);
          _showErrorDialog("Profile Updated");
//          Navigator.pop(context);


            setState(() {
              _isLoading = true;
            });

        }

      }

    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message);
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child:
        Text('Profile Edit', style: TextStyle(
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
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
//            _isLoading  ? LinearProgressIndicator(
//              backgroundColor: Colors.blue[208],
//              valueColor: AlwaysStoppedAnimation(Colors.blue),
//            ) : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(key: _formKey,
                child: Column(
                  children: <Widget>[
//                    CircleAvatar(
//                      radius: 50.0,
//                      backgroundColor: Colors.grey,
//                      backgroundImage: _displayProfileImage(),
//                    ),

                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(fontSize: 18.0),

                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.verified_user,
                          size: 30.0,
                        ),
                        labelText: 'Name',
                      ),
                      validator: (input)=> input.trim().isEmpty ? 'please enter a valid name' : null,
                      onSaved: (input)=> _name = input,

                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      initialValue: _phone,
                      style: TextStyle(fontSize: 18.0),

                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.phone,
                          size: 30.0,
                        ),
                        labelText: 'Phone Number',
                      ),
                      validator: (input)=> input.trim().length < 1 ? 'please enter a valid phone number' : null,
                      onSaved: (input)=> _phone = input,

                    ),
                    SizedBox(height: 5.0),



                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: Platform.isIOS ? CupertinoButton(
                        onPressed: _submit,
                        color: Colors.grey,
                        child: Text(
                          'Save Profile', style: TextStyle(
                          fontSize: 18.0,
                        ),
                        ),
                      ) : FlatButton(
                        onPressed: _submit,
                        color: Colors.grey,
                        textColor: Colors.white,
                        child: Text(
                          'Save Profile', style: TextStyle(
                          fontSize: 18.0,
                        ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}