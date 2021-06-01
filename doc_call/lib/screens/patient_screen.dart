import 'dart:convert';
import 'dart:io';

import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/patient.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/edit_profile.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/patient_update.dart';
import 'package:doc_call/screens/paystack_pay.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget
{
  final String doc, patient,type;
  @override
  _PatientScreenState createState() => _PatientScreenState();
  PatientScreen({this.doc, this.patient, this.type});
}

class _PatientScreenState extends State<PatientScreen>
{
  String _selected;
  User userData;
  List<Client> client;
  int _selectedItemIndex = 1;
  Client cls;
  @override
  void initState()
  {
    //TODO: implement initState
    super.initState();
    _getClient();


  }

  _getClient()async
  {
    List<Client> clients = await Provider.of<DatabaseService>(context, listen: false)
        .getClient2(widget.doc, widget.patient);
    if(mounted)
    {
      setState(()
      {
        client = clients;
        cls = clients[0];
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
        print(widget.doc + " "+ widget.type);

        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(userId: widget.doc, type: widget.type),
        ));


      }
      else if(_selected == 'home')
      {

        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>HomeScreen(email: widget.doc, type: widget.type),
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

  _update() async
  {


    final dbService = Provider.of<DatabaseService>(context, listen: false);

    try
    {





        List res = await dbService.deleteClient(cls.email);
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>HomeScreen(email: widget.doc, type: widget.type)),
                (Route<dynamic> route) => false,
          );

        }



    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message, "Error");
    }


  }

  _pay() async
  {
     Navigator.push(context, MaterialPageRoute(
       builder: (_)=>PaystackPay(client_email: cls.email)
     ));

  }





  _displayButton(Client client)
  {
    return Container(
      width: 195.0,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_)=>PatientUpdate(
              client: client),
        )),
        textColor: Colors.white,
        child: Text('Edit Client Information',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );

  }

  _displayButton2()
  {
    return Container(
      width: 195.0,
      child: FlatButton(
        color: Colors.grey,
        onPressed:_update,
        textColor: Colors.white,
        child: Text('Delete Client',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );

  }

  _displayButton3()
  {
    return Container(
      width: 195.0,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed:_pay,
        textColor: Colors.white,
        child: Text('Make Payment',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );

  }

  Image appLogo = new Image(
      image: new ExactAssetImage("assets/logo.png"),
      height: 40.0,
      width: 40.0,
      alignment: FractionalOffset.center);


  _buildProfileInfo(List<Client> client)
  {

    Client clients = client[0];

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 8.0),
          child: Row(
            children: <Widget>[


            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(clients.names != null ? clients.names : "Name",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(clients.email != null ? clients.email : "Email",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                height: 18.0,
                child: Text(clients.phone != null ? clients.phone : "Phone", style: TextStyle(
                  fontSize: 15.0,
                 ),
                ),
              ),
              SizedBox(height: 5.0),
              Text("Age"),
               Container(
                  height: 18.0,
                  child: Text(clients.age != null ? clients.age : "Sex", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ),
              SizedBox(height: 5.0),
              Text("Gender"),
              Container(
                  height: 18.0,
                  child: Text(clients.sex != null ? clients.sex : "Sex", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ),
              SizedBox(height: 5.0),
              widget.type == "agent" ? Text("Payment Status") :SizedBox.shrink(),
              widget.type == "agent" ? Container(
                  height: 18.0,
                  child: Text(clients.p_status != null ? clients.p_status : "not paid", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ) :SizedBox.shrink(),
              SizedBox(height: 5.0),
              widget.type == "agent" ? Text("Amount Paid") :SizedBox.shrink(),
              widget.type == "agent" ? Container(
                  height: 18.0,
                  child: Text(clients.amount != null ? clients.amount : "0", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ) :SizedBox.shrink()
            ],
          ),
        ),
        widget.type == "doc" ?_displayButton(clients) : SizedBox.shrink(),
        widget.type == "doc" ?_displayButton2() : SizedBox.shrink(),
        widget.type == "agent" && clients.amount == null ? _displayButton3() : SizedBox.shrink()
      ],
    );

  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          bottomNavigationBar: Row(
            children: <Widget>[

            ],
          ),
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
            bottom: TabBar(
              labelColor: Color.fromRGBO(42, 163, 237, 1),
              indicator: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(42, 163, 237, 1)))
              ),
              tabs: <Widget>[
                Tab(
                  text: 'Client Profile Information',
                )
              ],
            ),
          ),


          backgroundColor: Colors.white,

          body: FutureBuilder(
            future: _getClient(),
            builder: (BuildContext context, AsyncSnapshot snapshot)
            {


              return ListView(
                children: <Widget>
                [
                  Padding(
                    padding: EdgeInsets.all(10.0),

                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      client != null ? _buildProfileInfo(client) :
                      Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
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
  Widget buildNavBarItem(IconData icon,int index,String page)
  {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedItemIndex = index;
        });

        if(page != '')
        {
          Navigator.pushReplacementNamed(context, page);
        }
        else if(_selectedItemIndex == 1)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>HomeScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId),
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
//          gradient: LinearGradient(colors: [
//            Color.fromRGBO(42, 163, 237, 1).withOpacity(0.3),
//            Color.fromRGBO(42, 163, 237, 1).withOpacity(0.015)
//          ],
//          begin: Alignment.bottomCenter,
//          end: Alignment.topCenter)
//            color: index == _selectedItemIndex? Colors.green : Colors.white
        ) : BoxDecoration(),
        child: Icon(
            icon,
            size: 20,
            color:  index == _selectedItemIndex ? Color.fromRGBO(42, 163, 237, 1) : Colors.grey),
      ),
    );
  }
}
