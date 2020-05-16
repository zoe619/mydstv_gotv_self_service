
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/hello.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:mydstv_gotv_self_service/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

class RequestInstallation extends StatefulWidget
{
  @override
  _RequestInstallationState createState() => _RequestInstallationState();
}

class _RequestInstallationState extends State<RequestInstallation>
{

  bool _isLoading = false;
  final _installationFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _userId;
  User userData;
  String _email;

  String _selected;
  List<String> _packages = ["DStv", "GOtv"];
  List<String> _services = ["Installation", "Repairs", "Maintenance"];
  String _brand;
  String _service;
  String _address;


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();

    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
    getUserData();

  }

  getUserData() async{
    User user = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(_userId);
    setState(() {
      userData = user;
      _email = user.email;
    });

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

  _buildClearErrorForm(){
    return Form(
      key: _installationFormKey,
      child: Column(
        children: <Widget>
        [
          _buildPlanTF(),
          _buildServiceTF(),
          _buildAddressTF()

        ],
      ),

    );
  }

  _buildPlanTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 20.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _packages.map((String plan){
          return DropdownMenuItem(
            value: plan,
            child: Text(
              plan, style: TextStyle(
                color: Colors.black,
                fontSize: 15.0
            ),
            ),

          );
        }).toList(),
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            labelText: 'Choose a Brand',
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
        validator: (input)=>_brand == null
            ? "Please select a brand"
            : null,
        onChanged: (value)
        {
          setState(() {
            _brand = value;


          });

        },
        value: _brand != null ? _brand : null,
      ),

    );
  }

  _buildServiceTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 20.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _services.map((String plan){
          return DropdownMenuItem(
            value: plan,
            child: Text(
              plan, style: TextStyle(
                color: Colors.black,
                fontSize: 15.0
            ),
            ),

          );
        }).toList(),
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            labelText: 'Service Required',
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
        validator: (input)=>_service == null
            ? "Please select service required"
            : null,
        onChanged: (value)
        {
          setState(() {
            _service = value;


          });

        },
        value: _service != null ? _service : null,
      ),

    );
  }

  _buildAddressTF()
  {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Your Address'),
        validator: (input)=>
        input.trim().isEmpty  ? 'Address can\'t be empty' : null,
        onSaved: (input)=>_address = input.trim(),

      ),
    );
  }

  _submit() async {

    setState(() => _isLoading = false);
    if (!_installationFormKey.currentState.validate())
    {
      SizedBox.shrink();
    }

    else if (_isLoading == false)
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

      if (_installationFormKey.currentState.validate())
      {
        _installationFormKey.currentState.save();


        List res = await Provider.of<DatabaseService>(context, listen: false).requestInstallation(_brand, _service,
            _address, _email);


        Map<String, dynamic> map;

        for(int i = 0; i < res.length; i++)
        {
          map = res[i];

        }

        if(map['status'] == "fail")
        {
          _showErrorDialog(map['msg'], map['status']);
          setState(() => _isLoading = true);
        }
        else
        {
          _showErrorDialog(map['msg'], map['status']);

            setState(() => _isLoading = true);

        }



      }
    }
    on PlatformException catch(error){
      _showErrorDialog(error.message, "error");
    }


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
              Platform.isIOS ? CupertinoButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              ) : FlatButton(
                child: Text('Ok'),
                onPressed: (){
                  Navigator.pop(context);

                },
              )
            ],
          );
        }
    );

  }




  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child:
        Text('Services', style: TextStyle(
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),

          ),
          Welcome(),
          _buildClearErrorForm(),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Submit', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,

                  ),
                  ),
                  onPressed: _submit

              ),
            ),
          )
        ],
      ),
    );
  }
}
