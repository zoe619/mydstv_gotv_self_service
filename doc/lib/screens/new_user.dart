import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
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

  int _selectedItemIndex = 1;

  @override
  Widget build(BuildContext context) {



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
        prefixIcon: new Icon(Icons.email, color: Color.fromRGBO(42, 163, 237, 1)),
    hintText: 'Email Address',
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0)
    ),
    ),
    );

    final name = TextFormField(
    keyboardType: TextInputType.text,
    autofocus: false,
    decoration: InputDecoration(
    prefixIcon: new Icon(Icons.lock, color: Color.fromRGBO(42, 163, 237, 1)),
    hintText: 'Full Name',
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0)
    ),
    ),
    );

    final phone = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.phone, color: Color.fromRGBO(42, 163, 237, 1)),
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );

    final age = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
        hintText: 'Age',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
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
    child: Text('REGISTER', style: TextStyle(color: Colors.white),),
    )
    ),
    ),
    );

    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);


    return Scaffold(
    backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: <Widget>[
          buildNavBarItem(Icons.home,1,'dashboard'),
          buildNavBarItem(Icons.local_pharmacy,2,'get_prescription'),
          buildNavBarItem(Icons.supervised_user_circle,3,''),
          buildNavBarItem(Icons.settings,4,'')
        ],
      ),
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color.fromRGBO(182, 11, 5, 1),
            ),
            onPressed: () {
              // do something
            },
          )
        ],

        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),
    body: Center(
    child: ListView(
    shrinkWrap:true,
    padding:EdgeInsets.only(left: 24.0, right: 24.0),
    children: <Widget>[
    Text('+ New Client',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 30,),),
    SizedBox(height: 20.0),
    avatar,
    SizedBox(height: 48.0),
    name,
    SizedBox(height: 15.0,),
    email,
      SizedBox(height: 15.0,),
      phone,
      SizedBox(height: 15.0,),
      age,
    SizedBox(height: 24.0),
    loginButton
    ],
    ),
    ),
    );
  }
  Widget buildNavBarItem(IconData icon,int index,String page) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedItemIndex = index;
        });

        if(page != ''){
          Navigator.pushReplacementNamed(context, page);
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width/4,
        decoration:  index == _selectedItemIndex? BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2, color: Color.fromRGBO(42, 163, 237, 1))
          ),
        ) : BoxDecoration(),
        child: Icon(
            icon,
            size: 20,
            color:  index == _selectedItemIndex? Color.fromRGBO(42, 163, 237, 1) : Colors.grey)
        ,
      ),
    );
  }
}

