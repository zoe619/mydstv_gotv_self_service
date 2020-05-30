import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:mydstv_gotv_self_service/data/data.dart';
import 'package:mydstv_gotv_self_service/models/activities.dart';
import 'package:mydstv_gotv_self_service/models/mobilecustomer.dart';
import 'package:mydstv_gotv_self_service/models/products.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/activity_screen.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/screens/purchase_items_details.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/hello.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:mydstv_gotv_self_service/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PurchaseItems extends StatefulWidget
{
  @override
  _PurchaseItemsState createState() => _PurchaseItemsState();

  final String brand;
  PurchaseItems({this.brand});
}

class _PurchaseItemsState extends State<PurchaseItems>
{
  DateTime _date = DateTime.now();
  String _selected;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy').add_jm();
  String _userId;
  List<Products> products;
  User userData;
  String _name;
  int len;

  Random random = new Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateFormatter.format(_date);
//    _getItems();
     _userId = Provider.of<UserData>(context, listen: false).currentUserId;
  }



  _getItems()async
  {
    var table = "products";
    Provider.of<DatabaseService>(context, listen: false).getItems(table, widget.brand)
        .then((items)
        {

          if(mounted){
            setState(() {
              products = items;
              len = items.length;

            });
          }
       });
  }
  _getUserData() async
  {
    User user = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(_userId);
    setState(() {
      userData = user;
      _name = userData == null ? SizedBox.shrink() : userData.name;
    });

  }

  _dialPhone() async
  {

    String phone = "09081867279";

    String number = "tel:"+phone;
    launch(number);
    if (await canLaunch(number))
    {
      await launch(number);
    }
    else{

      phone = "08099926467";
      String number = "tel:"+phone;
      launch(number);
      if (await canLaunch(number))
      {
        await launch(number);
      }
      else{
        throw 'Could not place a call to $number';
      }
    }

  }

  void _sendSMS() async
  {

//    String phone = "08033169636";
    String message = "type a message";
    List<String> recipients = ["09081867279", "08099926467"];

    String _result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      print(onError);
    });



  }
  void choiceAction(PopUp pop)
  {

    setState(()
    {
      _selected = pop.option;

      if(_selected == 'profile')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(currentUserId: _userId),
        ));


      }
      else if(_selected == 'call')
      {
        _dialPhone();
      }
      else if(_selected == 'sms')
      {
        _sendSMS();
      }
      else if(_selected == 'log_out')
      {
        Provider.of<AuthService>(context, listen: false).logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }

    });

  }

  _buildItems()
  {
    List<Widget> productList = [];
    products == null ? Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator() :
    products.forEach((Products product){
      productList.add(
          GestureDetector(
            onTap: ()=>Navigator.push(context,
                MaterialPageRoute(
                  builder: (_)=>PurchaseItemDetails(products: product),
                )),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey[200],
                  )
              ),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      height: 150.0,
                      width: 150.0,
                      image: CachedNetworkImageProvider("https://mydstvgotvforselfservice.com/images/productimages/"+product.pic),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(product.name, style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          ),

                          SizedBox(height: 6.0),
                          Text("NGN"+product.price, style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,

                          ),
                            softWrap: true,
                            maxLines: 2,
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    });

    return Column(
        children: productList
    );


  }
  @override
  Widget build(BuildContext context)
  {

    final currentUserId = Provider.of<UserData>(context, listen: false).currentUserId;




    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child:
        Text('Purchase Items', style: TextStyle(
          color: Colors.white,
          fontSize: 32.0,
        ),)),

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

      ),
      body: FutureBuilder(
        future: _getItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),

              ),
              Welcome(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 1.0),
                    child: Center(
                      child: Text('Purchase Items', style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                      ),
                    ),
                  ),
                  products != null ? _buildItems() : Center(child: Platform.isIOS ? CupertinoActivityIndicator() :
                  CircularProgressIndicator()),
                ],
              )
            ],
          );
        },

      ),
    );
  }
}
