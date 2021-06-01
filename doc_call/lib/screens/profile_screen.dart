
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/doctor.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/edit_profile.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/user_details.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/utilities/constant.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget
{
  static String tag = 'profile';
  final String userId;
  final String type;

  ProfileScreen({Key key, this.userId, this.type}): super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen>
{

//  logo
  Image appLogo = new Image(
      image: new ExactAssetImage("assets/logo.png"),
      height: 40.0,
      width: 40.0,
      alignment: FractionalOffset.center);

  List<String> data;


  final images = ['assets/avatar.png','assets/avatar.jpg','assets/avatar.png','assets/avatar.jpg','assets/avatar.png','assets/avatar.jpg','assets/avatar.png','assets/avatar.jpg'];

  int _selectedItemIndex = 1;
  String _userId;

  User userData;

  String _email;
  String _name;
  String _type;
  String _phone;
  String _license;
  String _selected;
  List<User>user;
  User users;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
    print(widget.userId + " "+ widget.type);

  }
  _getData()async
  {

    List<User> us = await Provider.of<DatabaseService>(context, listen: false).getData(widget.userId, widget.type);
    if(mounted)
    {
      setState(()
      {
        user = us;
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
//        Navigator.push(context, MaterialPageRoute(
//          builder: (_)=>EditProfile(user: userData)
//        ));


      }
      else if(_selected == "home")
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>HomeScreen(email: widget.userId, type: widget.type),
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

  _displayButton(User user)
  {
    return Container(
      width: 195.0,
      child: FlatButton(
        color: Colors.grey,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_)=>EditProfile(
              user: user),
        )),
        textColor: Colors.white,
        child: Text('Edit Profile',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );

  }


  _buildProfileInfo(User user)
  {

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 8.0),
          child: Row(
            children: <Widget>[

              Expanded(
                child: Column(
                  children: <Widget>[
                    widget.type == "agent" ?  CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                        user.imageUrl == null ? AssetImage('assets/avatar.png')
                            : CachedNetworkImageProvider("https://doctor-on-call247.com/pizza/"+user.imageUrl)):SizedBox.shrink() ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                            children: <Widget>[
                              Text(user.name != null ? user.name : "Full Name", style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                               ),
                              ),
                              Text('Name', style: TextStyle(
                                color: Colors.black54,
                              ),
                              )
                            ],
                          ),

                      ],
                    ),
                    _displayButton(user),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text(user.email,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                  height: 18.0,
                  child: Text(user.phone != null ? user.phone : "Phone", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  ),
              ),

              widget.type == "doc" ? Container(
                  height: 18.0,
                  child: Text(user.license != null ? user.license : "License", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ) : SizedBox.shrink(),
              SizedBox(height: 5.0),
              widget.type == "agent" ? Container(
                  height: 18.0,
                  child: Text(user.company != null ? user.company : "Company", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ) : SizedBox.shrink(),
              SizedBox(height: 5.0),
              widget.type == "agent" ? Container(
                  height: 18.0,
                  child: Text(user.address != null ? user.address : "Address", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ): SizedBox.shrink(),
              widget.type == "agent" ? Container(
                  height: 18.0,
                  child: Text(user.code != null ? user.code : "Master Code", style: TextStyle(
                    fontSize: 15.0,
                  ),
                  )
              ): SizedBox.shrink(),
            ],
          ),
        ),
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
//              _type == "doc" ? buildNavBarItem(Icons.home,1,'dashboard') : SizedBox.shrink(),
//              _type == "pharm" ? buildNavBarItem(Icons.local_pharmacy,2,'get_prescription'): SizedBox.shrink(),
////              _type == "agent" ? buildNavBarItem(Icons.home,3,'') : SizedBox.shrink(),
//              buildNavBarItem(Icons.settings,4,'')
            ],
          ),
          appBar: AppBar(
            title: appLogo,
            actions: <Widget>[
//              IconButton(
//                icon: Icon(
//                  Icons.notifications,
//                  color: Color.fromRGBO(182, 11, 5, 1),
//                ),
//                onPressed: () {
//                  // do something
//                },
//              ),
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
                  text: 'Profile Information',
                )
              ],
            ),
          ),


          backgroundColor: Colors.white,

          body: FutureBuilder(
            future: _getData(),
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

                      user != null ? _buildProfileInfo(user[0]) : Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
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
            builder: (_)=>HomeScreen(email: widget.userId, type: widget.type),
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
