import 'dart:io';

import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/patient.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/screens/view_prescription.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GetPrescription extends StatefulWidget {
  @override
  _GetPrescriptionState createState() => _GetPrescriptionState();

  final Client client;
  final String email, name, type;
  GetPrescription({this.client, this.email, this.name, this.type});

}

class _GetPrescriptionState extends State<GetPrescription>
{

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _selectedItemIndex = 2;
  String _email;
  String _name;
  String _type;
  User userData;
  String _code;

  String _selected;

  List<Patient> pats;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getUserData();
    setState(() {
      _isLoading = true;
    });
    print(widget.email + " "+ widget.name + " " + widget.type);

  }



  void choiceAction(PopUp pop)
  {

    setState(()
    {
      _selected = pop.option;

      if(_selected == 'profile')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(userId: widget.email, type: widget.type),
        ));


      }
      else if(_selected == 'home')
      {

        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>HomeScreen(email: widget.email, type: widget.type),
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

  _buildCodeTF(){
    return TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.enhanced_encryption, color: Color.fromRGBO(42, 163, 237, 1)),
        hintText: 'Enter Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
      validator: (input)=>
      input.isEmpty ? 'Code Empty' : null,
      onSaved: (input)=>_code = input,
    );
  }

  _buildForm()
  {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildCodeTF(),
          SizedBox(height: 10.0),
        ],
      ),

    );
  }

  _submit() async
  {

    print(widget.email + " "+ widget.name);

    if(widget.name == null || widget.email == null)
    {
      _showErrorDialog("You Need To Update Your Profile Information To Proceed", "Error");
      SizedBox.shrink();
      return;
    }
    if(!_formKey.currentState.validate())
    {
      SizedBox.shrink();
      return;
    }



    setState(() => _isLoading = false);
    if(_isLoading == false)
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

      if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();

        List<Patient> pat = await dbService.getPatient2(_code);

        if(pat.length > 0)
        {
          setState(() {
            pats = pat;
          });
          setState(() => _isLoading = true);
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>ViewPrescription(patient: pats, email: widget.email, name: widget.name)
          ));
        }
        else
          {
          _showErrorDialog("Invalid Code", "Error");
        }

      }

    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message, "Error");
    }



  }

  @override
  Widget build(BuildContext context) {
    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);

    final presc =  Container(
        margin: EdgeInsets.only(left: 50,right: 40),
        child:  Text(
          "Get User's Prescription",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        )
    );

    final codebtn = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: RaisedButton(
              onPressed: _submit,
              color: Theme.of(context).primaryColor,
              child: Text('Submit', style: TextStyle(color: Colors.white,fontSize: 20)),

            )
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: <Widget>[
//          _type == "doc" ? buildNavBarItem(Icons.home,1,'dashboard') : SizedBox.shrink(),
//          _type == "pharm" ? buildNavBarItem(Icons.local_pharmacy,2,'get_prescription'): SizedBox.shrink(),
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
//            onPressed: () {
//              // do something
//            },
//          ),
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
            presc,
            SizedBox(height: 24.0),
            _buildForm(),
            SizedBox(height: 24.0),
            codebtn

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

