
import 'dart:io';

import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/dr_prescrips.dart';
import 'package:doc_call/screens/get_prescription.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/new_user.dart';
import 'package:doc_call/screens/patient_screen.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/screens/user_details.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget
{
  static String tag = 'dashboard';
  final String userId;
  final String email;
  final String type;


  @override
  _HomeScreenState createState() => _HomeScreenState();
  HomeScreen({Key key, this.email, this.type, this.userId}) : super(key: key);
}

class _HomeScreenState extends State<HomeScreen>
{

//  logo
  Image appLogo = new Image(
      image: new ExactAssetImage("assets/logo.png"),
      height: 40.0,
      width: 40.0,
      alignment: FractionalOffset.center);


  int _selectedItemIndex = 1;
  String _userId;

  User userData;

  String _email;
  String _name;
  String _type;
  String _selected;
  List<User>user;
  List<Client> client;
  String title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userId = widget.userId;
//    _getUserData();
    _getData();
    if(widget.type == "doc")
    {
      setState(() {
        title = "DOCTORS SPACE";
      });
    }
    else if(widget.type == "pharm"){
      setState(() {
        title = "PHARMACIST SPACE";
      });
    }
    else if(widget.type == "agent"){
      setState(() {
        title = "AGENTS SPACE";
      });
    }


  }

  _getData()async
  {

    List<User> users = await Provider.of<DatabaseService>(context, listen: false).getData(widget.email, widget.type);
    if(mounted)
    {
      setState(()
      {
        user = users;
        userData = user[0];
        _name = userData.name;
      });

    }
  }

  _getClient() async
  {

    List<Client> clients = await Provider.of<DatabaseService>(context, listen: false).getClient(widget.email);
    if(mounted)
    {
      setState(()
      {
        client = clients;
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


  _buildItems()
  {
    List<Widget> clientList = [];
    client == null ? Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator() :
    client.forEach((Client clients){
      clientList.add(
          GestureDetector(
            onTap: ()=>Navigator.push(context,
                MaterialPageRoute(
//                  builder: (_)=>PurchaseItemDetails(products: product),
                )),
            child: Container(
                child: Card(
              //
                    margin: EdgeInsets.only(bottom: 12.0),//                <-- Card widget
                    child: ListTile(
                    title: Text(clients.names,
                        style: TextStyle(
                            color: Color.fromRGBO(42, 163, 237, 1),
                            fontWeight: FontWeight.bold
                        )
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color:Color.fromRGBO(42, 163, 237, 1),size: 15,),
                    onTap: ()
                    {

                      widget.type == "doc" ?
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>UserDetails(client:clients,email: widget.email, name: _name),
                      )) : widget.type == "pharm" ?
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>GetPrescription(client:clients, email: widget.email, name: _name, type: widget.type),
                      )) :
                      widget.type == "agent" ?  Navigator.push(context, MaterialPageRoute(
                          builder: (_)=>PatientScreen(doc: widget.email, patient: clients.email, type: widget.type)
                      )):SizedBox.shrink();
                    },

                  ),
                ),

            ),
          ),
      );
    });

    return Column(
        children: clientList
    );


  }


  @override
  Widget build(BuildContext context)
  {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    setState(() {
      _userId = currentUserId;
    });
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          bottomNavigationBar: Row(
            children: <Widget>[
             widget.type == "doc" ? buildNavBarItem(Icons.view_agenda,1,'prescriptions') : SizedBox.shrink(),
             widget.type == "pharm" ? buildNavBarItem(Icons.local_pharmacy,2,'get_prescription'): SizedBox.shrink(),
////              _type == "agent" ? buildNavBarItem(Icons.home,1,'dashboard') : SizedBox.shrink(),
////              buildNavBarItem(Icons.supervised_user_circle,3,''),
//              buildNavBarItem(Icons.settings,4,'')
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
                widget.type == null  ?  Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
                CircularProgressIndicator()):
                widget.type == "agent" ?
               Tab(
                 text: 'LIST OF CLIENTS',
               ):
               Tab(
                  text: title + ' LIST OF PATIENTS',
                )
              ],
            ),
          ),

          backgroundColor: Colors.white,
          body: FutureBuilder(
            future: _getClient(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

              return ListView(
                children: <Widget>
                [
                  Padding(
                    padding: EdgeInsets.all(10.0),

                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      client != null ? _buildItems() : Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
                      CircularProgressIndicator()),
                    ],
                  )
                ],
              );
            },

          ),
          floatingActionButton: widget.type == "doc" || widget.type == "agent" ? FloatingActionButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_)=>NewUser(userId: widget.email, type: widget.type),
                ));
              },
              child: widget.type == "agent" ? Icon(Icons.sort) : widget.type == "doc" ?
              Icon(Icons.add) : SizedBox.shrink(),
              foregroundColor: Color.fromRGBO(183, 15, 9, 1),
              backgroundColor: Colors.white
          ):
          FloatingActionButton(
              onPressed: ()
              {
                String column = "pharm_email";
                Navigator.push(context, MaterialPageRoute(
                  builder: (_)=>Prescriptions(email: widget.email, column: column, type: widget.type),
                ));
              },
              child:
              Icon(Icons.present_to_all),
              foregroundColor: Color.fromRGBO(183, 15, 9, 1),
              backgroundColor: Colors.white
          ),

        )
    );
  }

  Widget buildNavBarItem(IconData icon,int index,String page)
  {
    return GestureDetector(
      onTap: (){
        setState(()
        {
          _selectedItemIndex = index;

        });

        if(_selectedItemIndex == 2)
        {

          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>GetPrescription(email: widget.email, name: _name, type: widget.type),
          ));
        }
        if(_selectedItemIndex == 1)
        {
          String column = "dr_email";
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>Prescriptions(email:widget.email, column: column, type: widget.type),
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
