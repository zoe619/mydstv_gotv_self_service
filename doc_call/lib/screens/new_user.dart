import 'dart:io';

import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
  final String userId, type;
  NewUser({Key key, this.userId, this.type}) : super(key: key);
  User user;

}

class _NewUserState extends State<NewUser>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _editFormKey = GlobalKey<FormState>();
  String name, email, phone, age, referer, sex;
  bool _isLoading = false;
  int group = 0;

  String _selected;
  String _type;

  File _image;
  User userData;
  List<User>user;

  @override
  void initState()
  {
    super.initState();
//    getUserData();
    _getData();
  }
  _getData()async
  {

    List<User> us = await Provider.of<DatabaseService>(context, listen: false).getData(widget.userId, widget.type);
    if(mounted)
    {
      setState(()
      {
        user = us;
        userData = us[0];
      });

    }
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

  void choiceAction(PopUp pop)
  {

    setState(()
    {
      _selected = pop.option;

      if(_selected == 'profile')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(userId: userData.id),
        ));


      }
      else if(_selected == 'home')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>HomeScreen(userId: userData.id),
        ));

      }
      else if(_selected == 'sms')
      {

      }
      else if(_selected == 'log_out')
      {

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
        );
      }

    });

  }


  @override
  Widget build(BuildContext context) {



    final avatar = GestureDetector(
      onTap: (){
//        _pickImage(ImageSource.gallery);
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

        keyboardType: TextInputType.number,
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

    _buildLicenseTF(){
      return TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Age',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A Valid Age' : null,
        onSaved: (input)=> age = input,
      );
    }

    _buildSexTF(){
      return TextFormField(
        autofocus: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.gamepad, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Sex',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A Valid Sex' : null,
        onSaved: (input)=> sex = input,
      );
    }


    _buildEditForm()
    {
      return Form(
        key: _editFormKey,
        child: Column(
          children: <Widget>[
            _buildEmailTF(),
            SizedBox(height: 10.0),
            _buildNameTF(),
            SizedBox(height: 10.0),
            _buildPhoneTF(),
            SizedBox(height: 10.0),
            _buildLicenseTF(),
            SizedBox(height: 10.0),
            _buildSexTF()
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
            new SnackBar(duration: new Duration(seconds: 1),
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


          List res = await dbService.addClient(name, email, phone, age, widget.userId, sex);
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

//            _showErrorDialog(map['msg'], map['status']);

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_)=>HomeScreen(email: widget.userId, type: widget.type),
            ));

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
              color: Theme.of(context).primaryColor,
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
//          _type == "doc" ? buildNavBarItem(Icons.home,1,'dashboard') : SizedBox.shrink(),
//          _type == "pharm" ? buildNavBarItem(Icons.local_pharmacy,2,'get_prescription') : SizedBox.shrink(),
//          buildNavBarItem(Icons.supervised_user_circle,3,''),
//          buildNavBarItem(Icons.settings,4,'')
        ],
      ),
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.notifications,
//              color: Color.fromRGBO(182, 11, 5, 1),
//            ),
//            onPressed: ()
//            {
//              // do something
//            },
//          )
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
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),
      body: Center(
        child: ListView(
          shrinkWrap:true,
          padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text('New Client',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 30,),),
//            SizedBox(height: 20.0),
//            avatar,
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

