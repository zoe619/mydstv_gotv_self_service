import 'dart:io';

import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_text/link_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:email_validator/email_validator.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _signupFormKey = GlobalKey<FormState>();
  String email, password, cpassword, table, user_type;
  bool _isLoading = false;
  int group = 0;
  bool isChecked = false;
  bool isChecked2 = false;
  final String _text = 'Lorem ipsum https://flutter.dev\nhttps://pub.dev';

  File _image;
  bool _obscureText = true;

  void _onRememberMeChanged(bool newValue) => setState(()
  {
    isChecked = newValue;


  });
  void _showPass(bool newValue) => setState((){
    isChecked2  = newValue;
    if (isChecked2 ) {
      setState(() {
        _obscureText = false;
      });


    } else {
      setState(() {
        _obscureText = true;
      });
    }
  });
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

  _buildConfirmTF()
  {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.lock, color: Color.fromRGBO(42, 163, 237, 1)),
        hintText: 'Confirm Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
      validator: (input)=>
      input.length < 6 ? 'Must be at least 6 chaacters' : null,
      onSaved: (input)=>cpassword = input,
      obscureText: _obscureText,
    );
  }
  _buildTerms(){
     return Checkbox(
         value: isChecked,
         onChanged: _onRememberMeChanged
     );
  }

  _showP(){
    return Checkbox(
        value: isChecked2,
        onChanged: _showPass
    );
  }
  _buildSignupForm()
  {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
          SizedBox(height: 10.0),
          _buildPasswordTF(),
          SizedBox(height: 10.0),
          _buildConfirmTF(),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Text("Show Password: "),
              _showP()
            ],
          ),

          Row(
            children: <Widget>[
              Text("Privacy Policy/Subscriber Terms: ", style: TextStyle(
                color: Theme.of(context).primaryColor
              ),),
              _buildTerms()
            ],

          )

        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context)
  {
    final logo = Hero(
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
        onTap: ()
        {
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



    _submit() async
    {

      setState(() => _isLoading = false);


      if(!_signupFormKey.currentState.validate())
      {
        SizedBox.shrink();
      }
      else if(!isChecked){
        SizedBox.shrink();
        _showErrorDialog("You Have To Accept The Subscriber Terms And Privacy Policy Agreement", "Error");
        return;
      }
      else if(group == 0)
      {
        SizedBox.shrink();
        _showErrorDialog("You Have To Select A User Type", "Error");
        return;
      }
      else if(password != cpassword)
      {
          SizedBox.shrink();
          _showErrorDialog("Confirm Password Do Not Match", "Error");
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

      final dbService = Provider.of<DatabaseService>(context, listen: false);

      try
      {

        if(_signupFormKey.currentState.validate())
        {
          _signupFormKey.currentState.save();

          final bool isValid = EmailValidator.validate(email);
          if(!isValid){
            _showErrorDialog("Email Is Wrong", "Fail");
            return;
          }

          if(group == 1)
          {
            setState(() {
              user_type = "agent";
              table = "agents";
            });
          }
          else if(group == 2){
            setState(() {
              user_type = "pharm";
              table = "pharmacist";
            });
          }
          else if(group == 3){
            setState(() {
              user_type = "doc";
              table = "doc";
            });
          }


          List res = await dbService.signUp(email, password, table);
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


            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_)=>HomeScreen(email: email, type: user_type)
            ));
//            String reg = await authService.signUp(email, password, user_type);
//            if(reg != null)
//            {
//              Provider.of<UserData>(context, listen: false).currentUserId = reg;
//            }
//            _showErrorDialog("Registration Successful, Email Verification Link Has Been Sent To Your Mail", map['status']);
//            setState(()
//            {
//              _isLoading = true;
//            });

          }


        }
      }
      on PlatformException catch (err) {
        _showErrorDialog(err.message, "error");
      }



    }




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

    final login = Container(
      margin: EdgeInsets.only(left: 24.0,right: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Already Have An Account? "),
                  GestureDetector(
                    onTap:() {
                      Navigator.pushReplacementNamed(context, 'login_page');
                    },
                    child: Text('Login now',style: TextStyle(
                        color: Color.fromRGBO(42, 163, 237, 1)
                    ),),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  InkWell(child: Text("View Privacy Policy ",
                      style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                    onTap: ()=>launch("https://doctor-on-call247.com/pizza/privacy.php"),
                  ),
                  SizedBox(width: 5.0),

                  GestureDetector(
                    onTap:() {

                    },
                    child: InkWell(
                      child: Text('View Subscribers Terms',style: new TextStyle(color: Colors.blue,
                          decoration: TextDecoration.underline),),
                      onTap: ()=>launch("https://doctor-on-call247.com/pizza/terms.php"),
                    ),
                  ),

                ],
              )
            ],
          )

        ],
      ),
    );

    final signButton = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: Platform.isIOS ? CupertinoButton() : RaisedButton(
              onPressed: _submit,
              color: Theme.of(context).primaryColor,
              child: Text('SIGN UP',
                style: TextStyle(color: Colors.white),

              ),

            )
        ),
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
          logo,
          Container(
          margin: EdgeInsets.only(left: 60,right: 10),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Text(
          'Doc On',
          style: TextStyle(
          color: Theme.of(context).primaryColor,
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

          SizedBox(height: 48.0),
          _buildSignupForm(),
          SizedBox(height:8.0),
           type,
//          SizedBox(height: 8.0,),
//          password,
//            SizedBox(height:8.0),
//            cpassword,
          SizedBox(height: 24.0),
          signButton,
            SizedBox(height: 28.0,),
            login
          ],
          ),
          ),
          );
  }

}
