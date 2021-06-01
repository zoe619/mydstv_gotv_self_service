import 'dart:io';


import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int group = 0;
  String table;

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
        keyboardType: TextInputType.emailAddress,
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
    else if(group == 0)
    {
      SizedBox.shrink();
      _showErrorDialog("You Have To Select A User Type", "Error");
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
      if(_resetFormKey.currentState.validate())
      {
        _resetFormKey.currentState.save();
        if(group == 2){
          setState(() {
            table = "pharmacist";

          });
        }
        else if(group == 3)
        {
          setState(() {
            table = "doc";

          });
        }
        else{
          table = "agents";
        }
        final dbService = Provider.of<DatabaseService>(context, listen: false);
        List res = await dbService.pwdReset(_email, table);


        Map<String, dynamic> map;



        for (int i = 0; i < res.length; i++)
        {
          map = res[i];
        }
        if(map['status'] == "fail")
        {
          _showErrorDialog(
              map['msg'],
              "Error");
          return;
        }
        else{
          _showErrorDialog(
              map['msg'],
              "Success");
            return;
        }


//        await authService.sendPasswordReset(_email);
//        _showErrorDialog("password reset link has been sent to your mail", "success");
//        setState(() {
//          _isLoading = true;
//        });

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

    final type = Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 1 ,
                        groupValue: group,
                        activeColor: Color.fromRGBO(42, 163, 237, 1) ,
                        onChanged: (T){
                          setState(() {
                            group = T;
                          });
                        },
                      ),
                      Text("Agent"),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 2 ,
                        groupValue: group,
                        activeColor: Color.fromRGBO(42, 163, 237, 1) ,
                        onChanged: (T){
                          setState(() {
                            group = T;
                          });
                        },
                      ),
                      Text("Pharmacist"),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 3,
                        groupValue: group,
                        activeColor: Color.fromRGBO(42, 163, 237, 1) ,
                        onChanged: (T){
                          setState(() {
                            group = T;
                          });
                        },
                      ),
                      Text("Doctor"),
                    ],
                  ),
                ),

              ],
            ),

          )
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                type,
                SizedBox(height: 48.0,),
                Container(
                  margin: EdgeInsets.only(left: 70,right: 40, top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Doc On',
                        style: TextStyle(
                            color: Color.fromRGBO(42, 163, 237, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                      Text(
                        ' Call',
                        style: TextStyle(
                            color: Color.fromRGBO(183, 15, 9, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        '24/7',
                        style: TextStyle(
                            color: Color.fromRGBO(42, 163, 237, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),


                    ],
                  ),
                ),
                SizedBox(height: 20.0),
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
