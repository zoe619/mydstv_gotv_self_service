import 'dart:io';
import 'dart:math';

import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/reset_password.dart';
import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget
{
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();
  String email, password, table, user_type;
  bool _isLoading = false;
  File _image;
  int group = 0;
  bool isChecked = false;


  bool _obscureText = true;
 
  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = selected;
    });
  }

  void _clear(){
    setState(() => _image = null);
  }

  Future<void> _cropImage()async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: _image.path
    );

    setState(() {
      _image = cropped ?? _image;
    });
  }

  _buildEmailTF()
  {

    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.person_pin, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Email Address',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=>
        !input.contains('@') ? 'Please Enter A Valid Email' : null,
        onSaved: (input)=>email = input

    );
  }

  _buildPasswordTF()
  {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.lock, color: Color.fromRGBO(42, 163, 237, 1)),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
      validator: (input)=>
      input.length < 6 ? 'Must be at least 6 chaacters' : null,
      onSaved: (input)=>password = input,
      obscureText: _obscureText,
    );
  }

  _buildSignupForm()
  {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
          SizedBox(height: 10.0),
          _buildPasswordTF(),
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Text("Show Password: "),
              _buildTerms()
            ],
          )
        ],
      ),

    );
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

  _buildTerms(){
    return Checkbox(
        value: isChecked,
        onChanged: _onRememberMeChanged
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(()
  {
    isChecked = newValue;

    if (isChecked) {
      setState(() {
        _obscureText = false;
      });

    } else {
      setState(() {
        _obscureText = true;
      });
    }
  });

  _submit() async
  {
    setState(() => _isLoading = false);

      if (!_loginFormKey.currentState.validate())
      {
        SizedBox.shrink();
      }
      else if(group == 0)
      {
        SizedBox.shrink();
        _showErrorDialog("You Have To Select A User Type", "Error");
        return;
      }

      else if (_isLoading == false)
      {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(duration: new Duration(seconds: 2),
              content:
              new Row(
                children: <Widget>[
                  Platform.isIOS
                      ? new CupertinoActivityIndicator()
                      : new CircularProgressIndicator(),
                  new Text("please wait...")
                ],
              ),
              action: new SnackBarAction(
                  label: 'OK',
                  onPressed: () =>
                      _scaffoldKey.currentState.removeCurrentSnackBar()),
            ));
      }


        try {
          if (_loginFormKey.currentState.validate())
          {
            _loginFormKey.currentState.save();
            final dbService = Provider.of<DatabaseService>(context, listen: false);
            if(group == 2){
              setState(() {
                table = "pharmacist";
                user_type = "pharm";
              });
            }
            else if(group == 3)
            {
              setState(() {
                table = "doc";
                user_type = "doc";
              });
            }
            else{
              user_type = "agent";
              table = "agents";
            }


            List res = await dbService.login(email, password, user_type);
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
            else
              {


                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) =>
                      HomeScreen(email: email, type: user_type),
                ));


//              String login = await authService.login(email, password);
//
//
//              if (login != null)
//              {
//                Provider
//                    .of<UserData>(context, listen: false)
//                    .currentUserId = login;
//                Navigator.pushReplacement(context, MaterialPageRoute(
//                  builder: (_) =>
//                      HomeScreen(userId: Provider
//                          .of<UserData>(context, listen: false)
//                          .currentUserId),
//                ));
//              }
//              else {
//                _showErrorDialog(
//                    "Please Check Your Email To Verify Your Account", "error");
//              }
            }
          }
        }
        on PlatformException catch (err) {
          _showErrorDialog(err.message, "error");
        }





  }



  @override
  Widget build(BuildContext context)
  {

    final _logo = Hero(
      tag: 'hero1',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset(
            'assets/logo.png',
          width: 50,
          height: 50,
        ),

      ),
    );
    
    final avatar = GestureDetector(
      onTap: (){
        _pickImage(ImageSource.gallery);
      },

      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: _image == null
            ? Image.asset('assets/avatar.png')
            : Image.file(_image),

      ),

      
    );
        

    final loginButton = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
          height: 60,
            child: RaisedButton(
              onPressed: _submit,
              color: Theme.of(context).primaryColor,
              child: Text('SIGN IN', style: TextStyle(color: Colors.white),),
            )
        ),
      ),
    );

    final reg = Container(
      margin: EdgeInsets.only(left: 24.0,right: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Don't Have An Account ?   "),
          GestureDetector(
            onTap:() {
              Navigator.pushReplacementNamed(context, 'register');
            },
            child: Text('Register now',style: TextStyle(
              color: Color.fromRGBO(42, 163, 237, 1)
            ),),
          )
        ],
      ),
    );

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
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Center(
        child: ListView(
          shrinkWrap:true,
          padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            _logo,
            Container(
              margin: EdgeInsets.only(left: 60,right: 10),
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
                    SizedBox(width: 5.0),
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

            SizedBox(height: 48.0,),
            type,
            SizedBox(height: 8.0),
            _buildSignupForm(),
            SizedBox(height: 24.0),
            loginButton,
            SizedBox(height: 30.0),
            reg,
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (_)=>ResetPassword(),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(left:25.0),
                child: Text("forgot password?", style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
