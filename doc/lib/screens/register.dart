import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int group = 1;

  File _image;

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

  @override
  Widget build(BuildContext context) {
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
    final email = TextFormField(
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
    );

    final password = TextFormField(
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
    );

    final cpassword = TextFormField(
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

    final login = Container(
      margin: EdgeInsets.only(left: 24.0,right: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Already Have An Account ?   "),
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
    );

    final loginButton = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: RaisedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'login_page');
              },
              color: Color.fromRGBO(171, 171, 171, 1),
              child: Text('SIGN UP', style: TextStyle(color: Colors.white),),
            )
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
        child: ListView(
        shrinkWrap:true,
        padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
          logo,
          Container(
          margin: EdgeInsets.only(left: 80,right: 40),
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
          )


          ],
          ),
          ),
          SizedBox(height: 20.0),
          avatar,
          SizedBox(height: 48.0),
          email,
          SizedBox(height:8.0),
          type,
          SizedBox(height: 8.0,),
          password,
            SizedBox(height:8.0),
            cpassword,
          SizedBox(height: 24.0),
          loginButton,
            SizedBox(height: 28.0,),
            login
          ],
          ),
          ),
          );
  }
}
