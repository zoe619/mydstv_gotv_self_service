import 'dart:io';


import 'package:doc_call/models/patient.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Prescriptions extends StatefulWidget
{
  @override
  _PrescriptionsState createState() => _PrescriptionsState();
  final String email, column, type;
  Prescriptions({this.email, this.column, this.type});

}

class _PrescriptionsState extends State<Prescriptions>
{
  List<Patient> pats;

  String _selected;
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    print(widget.email + " "+ widget.type);


  }

  getPatientData() async
  {



    List<Patient> pat = await Provider.of<DatabaseService>(context, listen: false).getPatient4(widget.email, widget.column);
    if(mounted)
    {
      setState(() {
        pats = pat;
      });
    }

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

  Image appLogo = new Image(
      image: new ExactAssetImage("assets/logo.png"),
      height: 40.0,
      width: 40.0,
      alignment: FractionalOffset.center);

  _buildItems()
  {
    List<Widget> presList = [];
    pats == null ? Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator() :
    pats.forEach((Patient pat)
    {
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
                Text(pat.name,style: TextStyle(
                    color: Colors.white,fontSize: 10
                ),),
                Text('    '),
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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[
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
          child: FutureBuilder(
            future: getPatientData(),
            builder: (BuildContext context, AsyncSnapshot snapshot)
            {

              return ListView(
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(left: 24.0, right: 24.0),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text('Prescriptions'),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      pats != null ? _buildItems() : Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
                      CircularProgressIndicator()),
                    ],
                  )
                ],
              );
            },

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
