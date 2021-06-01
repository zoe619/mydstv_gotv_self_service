import 'dart:io';
import 'dart:ui';

import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PatientUpdate extends StatefulWidget {
  @override
  _PatientUpdateState createState() => _PatientUpdateState();
  final Client client;
  PatientUpdate ({this.client});
}

class _PatientUpdateState extends State<PatientUpdate >
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _editFormKey = GlobalKey<FormState>();
  String name, email, phone, age,sex;
  bool _isLoading = false;
  int group = 0;


  File _image;

  @override
  void initState()
  {
    super.initState();
    phone = widget.client.phone;
    name = widget.client.names;
    email = widget.client.email;
    age = widget.client.age;
    sex = widget.client.sex;


  }

  Future<void> _pickImage(ImageSource source) async
  {
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
    _buildEmailTF(){
      return TextFormField(
        initialValue: email,
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
        validator: (input)=>
        !input.contains('@') ? 'Please Enter A Valid Email' : null,
        onSaved: (input)=>email = input,
      );
    }

    _buildNameTF()
    {
      return TextFormField(
        initialValue: name,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.supervised_user_circle, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Full Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A Valid Name' : null,
        onSaved: (input)=> name = input,
      );
    }


    _buildPhoneTF()
    {
      return TextFormField(
        initialValue: phone,
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
        validator: (input)=> input.trim().isEmpty ? 'please enter a valid phone number' : null,
        onSaved: (input)=>phone = input,
      );
    }

    _buildGenderTF(){
      return TextFormField(
        initialValue: sex,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Gender',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A Valid Gender' : null,
        onSaved: (input)=> sex = input,
      );
    }

    _buildAgeTF(){
      return TextFormField(
        initialValue: age,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Company',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A Valid Age' : null,
        onSaved: (input)=> age = input,
      );
    }



    _buildEditForm()
    {
      return Form(
        key: _editFormKey,
        child: Column(
          children: <Widget>[
//            _buildEmailTF(),
            _buildNameTF(),
            SizedBox(height: 10.0),
            _buildPhoneTF(),
            SizedBox(height: 10.0),
            _buildGenderTF(),
            SizedBox(height: 10.0),
            _buildAgeTF(),
            SizedBox(height: 10.0),
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

    _submit() async
    {

      setState(() => _isLoading = false);


      if(!_editFormKey.currentState.validate())
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

        if(_editFormKey.currentState.validate())
        {
          _editFormKey.currentState.save();

          print(name + " "+ email+ " "+phone + " "+sex+ " "+age);


          List res = await dbService.updateClient(name, email, phone, sex, age);
          Map<String, dynamic> map;

          for(int i = 0; i < res.length; i++)
          {
            map = res[i];

          }

          if(map['status'] == "Fail")
          {
            _showErrorDialog(map['msg'], map['status']);
          }
          else
          {
            Navigator.pop(context);



          }


        }
      }
      on PlatformException catch (err) {
        _showErrorDialog(err.message, "Error");
      }



    }

    final loginButton = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: RaisedButton(
              onPressed: _submit,
              color: Color.fromRGBO(171, 171, 171, 1),
              child: Text('Submit', style: TextStyle(color: Colors.white),),
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: <Widget>[

        ],
      ),
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[

        ],

        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),
      body: Center(
        child: ListView(
          shrinkWrap:true,
          padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text('Profile Update',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 30,),),
            SizedBox(height: 20.0),
            SizedBox(height: 48.0),
            _buildEditForm(),
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
        if(_selectedItemIndex == 1)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>HomeScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId),
          ));

        }

        else if(_selectedItemIndex == 4)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>ProfileScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId),
          ));

        }
        else if(_selectedItemIndex == 3)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>HomeScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId),
          ));

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

