import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mydstv_gotv_self_service/screens/home_screen.dart';
import 'package:mydstv_gotv_self_service/screens/reset_password.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  String _name, _email, _password, _phone;

  _buildLoginForm(){
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),

    );
  }


  _buildSignupForm(){
    return Form(
      key: _signupFormKey,
      child: Column(
        children: <Widget>[
          _buildNameTF(),
          _buildEmailTF(),
          _buildPasswordTF(),
          _buildPhoneTF(),
        ],
      ),

    );
  }

  _buildNameTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (input)=>
        input.trim().isEmpty  ? 'Name can\'t be empty' : null,
        onSaved: (input)=>_name = input.trim(),

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


  _buildPhoneTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'phone number'),
        validator: (input)=>
        input.trim().isEmpty  ? 'phone can\'t be empty' : null,
        onSaved: (input)=>_phone = input.trim(),

      ),
    );
  }

  _buildPasswordTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Password'),
        validator: (input)=>
        input.length < 6 ? 'Must be at least 6 chaacters' : null,
        onSaved: (input)=>_password = input,
        obscureText: true,
      ),

    );
  }


  _submit() async
  {


    if(_selectedIndex == 0 && !_loginFormKey.currentState.validate())
    {
      SizedBox.shrink();
    }
    else if(_selectedIndex == 1 && !_signupFormKey.currentState.validate()){
      SizedBox.shrink();
    }

    else if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 5),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS
                    ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
          ));



    }
    final authService = Provider.of<AuthService>(context, listen: false);
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    try
    {
      if (_selectedIndex == 0 && _loginFormKey.currentState.validate())
      {

        _loginFormKey.currentState.save();
        bool login = await authService.login(_email, _password);

          setState(() {
            _isLoading = true;
          });

        if(login)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>HomeScreen(),
          ));
        }
        else{
          _showErrorDialog("please check your email to verify your account", "error");
        }

      }
      else
      if (_selectedIndex == 1 && _signupFormKey.currentState.validate())
      {
        _signupFormKey.currentState.save();


        List res = await dbService.addUser(_name, _email, _phone, _password);
        Map<String, dynamic> map;

        for(int i = 0; i < res.length; i++)
        {
          map = res[i];

        }

        if(map['status'] == "fail")
        {
          _showErrorDialog(map['msg'], map['status']);
        }
        else
        {
          await authService.signUp(_name, _email, _password, _phone);
          _showErrorDialog2("An email verification link has been sent to your mail", "success");


            setState(() {
              _isLoading = true;
            });


        }


      }
    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message, "error");
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
                child: Text('ok'),
                onPressed: ()=>Navigator.pop(context),
              ) : FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.pop(context);

                }
              )
            ],
          );
        }
    );

  }

  _showErrorDialog2(String errMessage, String status)
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
                child: Text('ok'),
                onPressed: ()=>Navigator.popAndPushNamed(context, "/homePage"),
              ) : FlatButton(
                child: Text('ok'),
                onPressed: ()=> Navigator.popAndPushNamed(context, "/homePage"),
              )
            ],
          );
        }
    );

  }


  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
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
                  'Welcome',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      child: Platform.isIOS
                          ? new CupertinoButton(
                      ) : FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),
                        color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.grey[400],
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: _selectedIndex == 0 ? Colors.white : Colors.black
                          ),
                        ),
                        onPressed: ()=> setState(()=> _selectedIndex = 0),
                      ),
                    ),
                    Container(
                      width: 150.0,
                      child: Platform.isIOS
                          ? new CupertinoButton() : FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),
                        color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.grey[400],
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: _selectedIndex == 1 ? Colors.white : Colors.black
                          ),
                        ),
                        onPressed: ()=> setState(()=> _selectedIndex = 1),
                      ),
                    )
                  ],
                ),

                _selectedIndex == 0 ? _buildLoginForm() : _buildSignupForm(),
                const SizedBox(height: 20.0),
                Container(
                  width: 180.0,
                  child: Platform.isIOS
                      ? new CupertinoButton() : FlatButton(
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
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_)=>ResetPassword(),
                    ));
                  },
                  child: Text("forgot password?", style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14.0,
                  ),),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
