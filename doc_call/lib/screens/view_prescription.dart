import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/patient.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ViewPrescription extends StatefulWidget {
  @override
  _ViewPrescriptionState createState() => _ViewPrescriptionState();

  List<Patient> patient;
  String email, name;
  ViewPrescription({this.patient, this.email, this.name});
}

class _ViewPrescriptionState extends State<ViewPrescription>
{

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _name;
  String _type;
  User userData;
  int _selectedItemIndex = 2;
  bool _isLoading = false;

  List<Patient> pat;

  List<Patient> pats;
  Patient patient;
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    pat = widget.patient;

    patient = pat[0];

  }


  getPatientData() async
  {


    List<Patient> pat = await Provider.of<DatabaseService>(context, listen: false).getPatient3(patient.email, widget.email);
    if(mounted)
    {
      setState(() {
        pats = pat;
      });
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

  _buildItems()
  {
    List<Widget> presList = [];
    pats == null ? Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator() :
    pats.forEach((Patient pat){
      presList.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding:EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color.fromRGBO(112, 112, 112, 1)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(pat.prescription_date,style: TextStyle(
                    color: Colors.white,fontSize: 10
                ),),
                Text('    '),
                Expanded(
                  child: Text(pat.prescription,style: TextStyle(
                      color: Colors.white,fontSize: 10
                  ),),
                ),
                pat.picture != null ?
                GestureDetector(
                  child: Container(
                    height: 40.0,
                    width: 50.0,
                    child: Image.network(
                      'https://doctor-on-call247.com/pizza/'+pat.picture,
                    ),
                  ),
                  onTap:()async
                  {

                    await showDialog(
                      context: context,
                      builder: (_)=>ImageDialog2('https://doctor-on-call247.com/pizza/'+pat.picture),
                    );
                  },
                ): SizedBox.shrink()
              ],

            ),

          ),
        ),

      );
    });

    return Column(
        children: presList
    );


  }


  _submit() async
  {


    if(widget.name == null || widget.email == null)
    {
      _showErrorDialog("You Need To Update Your Profile Information To Proceed", "Error");
      SizedBox.shrink();
      return;
    }

    setState(() => _isLoading = false);
    if(_isLoading == false)
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

        List res = await dbService.updatePrescription(widget.name, widget.email, patient.code);

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

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>HomeScreen(email: widget.email, type: "pharm")),
                  (Route<dynamic> route) => false,
           );

        }


    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message, "Error");
    }



  }

  _displayImage()
  {
    return GestureDetector(
      onTap:()async
      {
        patient.picture != null ?
        await showDialog(
          context: context,
          builder: (_)=>ImageDialog(patient.picture),
        ) : SizedBox.shrink();
      },
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider("https://doctor-on-call247.com/pizza/"+patient.picture),
      ),
    );
  }


  @override
  Widget build(BuildContext context)
  {
    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);

    final presc =Container(
        padding:EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(242, 241, 241, 1)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.scatter_plot,color: Color.fromRGBO(112, 112, 112, 1)),
            Text('    '),
            Expanded(
              child: Text(patient.prescription,style: TextStyle(
                  color: Colors.black,fontSize: 10
              ),),
            ),

          ],
        ),
      );

    final pay = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            width: 80,
            child: RaisedButton(
              onPressed:_submit,
              color: Color.fromRGBO(42, 163, 237, 1),
              child: Text('SOLD', style: TextStyle(color: Colors.white,fontSize: 20)),

            )
        ),
      ),
    );

    final cancel = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            margin:  EdgeInsets.only(left: 20,right: 90),
            child: RaisedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'get_prescription');
              },
              color: Color.fromRGBO(171, 171, 171, 1),
              child: Text('NOT SOLD', style: TextStyle(color: Colors.white,fontSize: 20)),

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

        ],

        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),
      body: Center(
        child: FutureBuilder(
          future: getPatientData(),
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {

            return ListView(
              shrinkWrap:true,
              children: <Widget>[
                Text('Name: '+patient.name,style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 24.0),
                Text('Prescriptions',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),),
                Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    presc,
                    SizedBox(height: 10.0),
                    patient.picture != null ? _displayImage() : SizedBox.shrink(),
                    SizedBox(height: 24.0),
                    Container(
                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            cancel,
                            pay
                          ],
                        )
                    ),
                    SizedBox(height: 40.0),
                    Text('Previous Prescriptions'),
                    SizedBox(height: 20.0),
                  ],

                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildItems(),
                  ],
                )
              ],
            );
          },

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

class ImageDialog extends StatelessWidget
{

  final String _img;

  ImageDialog(this._img);
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 2,
          child: Image(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            image: CachedNetworkImageProvider("https://doctor-on-call247.com/pizza/"+_img),
            fit: BoxFit.cover,
          ),

        )

    );
  }
}

class ImageDialog2 extends StatelessWidget
{

  final String pic;

  ImageDialog2(this.pic);
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 2,
          child: Image.network(pic),

        )

    );
  }
}

