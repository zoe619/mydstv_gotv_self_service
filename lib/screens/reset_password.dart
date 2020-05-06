import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget
{
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
{

  final _resetFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  String _email;

  _buildResetForm(){
    return Form(
      key: _resetFormKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
        ],
      ),

    );
  }

  _buildEmailTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (input)=>
        !input.contains('@') ? 'Please enter a valid email' : null,
        onSaved: (input)=>_email = input,

      ),
    );
  }

  _submit() async{


    if(!_resetFormKey.currentState.validate())
    {
      SizedBox.shrink();
    }

    else if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 5),
            content:
            new Row(
              children: <Widget>[
               Platform.isIOS ? CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
          ));



    }
    final authService = Provider.of<AuthService>(context, listen: false);


    try
    {
      if(_resetFormKey.currentState.validate())
      {
        _resetFormKey.currentState.save();

        await authService.sendPasswordReset(_email);
        _showErrorDialog("password reset link has been sent to your mail", "success");
        setState(() {
          _isLoading = true;
        });

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Center(child:
          Text('MyDStv GOtv Self Support', style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(
                  'Enter your email to get a password reset link',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      child: Platform.isIOS ? CupertinoButton()  : FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),


                      ),
                    ),
                    Container(
                      width: 150.0,
                      child: Platform.isIOS ? CupertinoButton() : FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),

                      ),
                    )
                  ],
                ),

                 _buildResetForm(),
                const SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: Platform.isIOS ? CupertinoButton() : FlatButton(
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
                SizedBox(height: 10.0),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
