import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:provider/provider.dart';


class Welcome extends StatefulWidget
{
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome>
{

  User userData;
  String _selected;
  String _userId;
  String _email;
  String _name;

  final DateTime date = DateTime.now();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy').add_jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
    getUserData();

  }

  getUserData() async{
    User user = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(_userId);
    if(mounted){
      setState(() {
        userData = user;
        _email = userData.email;
        _name = userData.name;
      });
    }

  }

  _buildStart(BuildContext context)
  {
    return Container(
      width: 320.0,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 1.0,
          color: Colors.grey[200],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[

                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text("Hi, $_name. What a great day \n to be alive!", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 8.0,
                          ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),

                        SizedBox(height: 4.0),


                        Text(_dateFormatter.format(date), style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 15.0),
                        Flexible(
                          child: Text("Customer Care: 09081867279; 08099926467", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 8.0,
                            color: Theme.of(context).primaryColor
                          ),

                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

            ),
          ),

          Container(
            margin: EdgeInsets.only(right: 20.0),
            width: 48.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: CircleAvatar(
              child: Image(
                height: 200.0,
                width: 200.0,
                image: AssetImage("assets/images/happy.jpg"),
                fit: BoxFit.cover,
              ),
            ),

          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          height: 120.0,
          child: _buildStart(context),

        ),

      ],
    );
  }
}
