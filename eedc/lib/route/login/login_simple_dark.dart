import 'dart:io';

import 'package:eedc/route/form/form_profile_data.dart';
import 'package:eedc/route/profile/bills.dart';
import 'package:eedc/services/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eedc/data/img.dart';

import 'package:flutter/services.dart';

class LoginSimpleDarkRoute extends StatefulWidget
{
  LoginSimpleDarkRoute();

  @override
  LoginSimpleDarkRouteState createState() => new LoginSimpleDarkRouteState();
}

class LoginSimpleDarkRouteState extends State<LoginSimpleDarkRoute>
{
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String username,password;
  bool _isLoading = false;

  _submit() async
  {
    setState(() => _isLoading = false);

    if(!_formKey.currentState.validate())
    {
      SizedBox.shrink();
      return;
    }

    else if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 2),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS
                    ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
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
      if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();


        var token = username+':'+password;

        bool response = await Server.login(token);

        if(response)
        {

          Navigator.of(context).pushReplacementNamed('/bills');
        }
        else{

          _showErrorDialog('Invalid login details', 'error');

        }

      }
    } on PlatformException catch (err) {
      print(err);
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
              Platform.isIOS
                  ? new CupertinoButton(
                child: Text('Ok'),
                onPressed: ()=>Navigator.pop(context),
              ) : FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);

                  }
              )
            ],
          );
        }
    );

  }
  

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey[900],
      appBar: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(0)
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Spacer(),
            Container(
              child: Image.asset(
                Img.get('logo_small_round.png'),
                color: Colors.green[300],
              ),
              width: 80, height: 80,
            ),
            Form(
                key: _formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 1.2,
                  child: Column(
                   children: [
                  Container(height: 15),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(labelText: "Username",
                        labelStyle: TextStyle(color: Colors.blueGrey[400]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[400], width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[400], width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "username required";
                        }
                        return null;
                      },
                      onSaved: (value) => username = value
                  ),
                  Container(height: 25),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(labelText: "Password",
                        labelStyle: TextStyle(color: Colors.blueGrey[400]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[400], width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey[400], width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "password required";
                        }
                        return null;
                      },
                      onSaved: (value) => password = value
                  ),
                  Container(height: 5),
                  Row(
                    children: <Widget>[
                      Spacer(),

                    ],
                  ),
                  Spacer(),
                  Container(
                    width: 200,
                    height: 40,
                    child: FlatButton(
                      child: Text("Login",
                        style: TextStyle(color: Colors.black),),
                      color: Colors.green[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)
                      ),
                      onPressed: _submit
                    ),
                  ),

                  Spacer(),
              ],
            ),
                ))
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),

    );
  }

}