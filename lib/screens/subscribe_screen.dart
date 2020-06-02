import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/bouquet.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/paystack_pay.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:mydstv_gotv_self_service/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class Subscribe extends StatefulWidget {
  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe>
{
  String _selected;
  String _userId;
  User userData;
  String _iuc;
  String _package;
  String _month;
  String _plan;
  String _bouq;
  int _price;
  int _startPrice;
  int service_fee;
  String _email;
  bool _isLoading = false;
  final _subscribeFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Bouquet>_bouquets;
  List<Bouquet>_bouquetsP;
  List<Bouquet> _bouqs;
  Bouquet _singleBouquet;

  List<String> _packages = ["DStv", "GOtv"];
  List<String> _months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
  var publicKey = '[]';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
    getUserData();
    _getItems();
    _getItems2();

  }


  getUserData() async{
    User user = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(_userId);
    setState(() {
      userData = user;
      _email = user.email;
    });

  }

  _getItemsPerBrand(String brand){

    Provider.of<DatabaseService>(context, listen: false).getBouquetPerBrand(brand)
        .then((items)
    {

      setState(()
      {
        _bouq = null;
        _bouqs = items;

      });
    });
  }

  _getItems()async
  {
    Provider.of<DatabaseService>(context, listen: false).getBouquet()
        .then((items)
    {

      setState(() {
        _bouquets = items;

      });
    });
  }

  _getItems2()async
  {
    var table = "bouquet_new";
    Provider.of<DatabaseService>(context, listen: false).getBouquet()
        .then((items)
    {

      setState(() {
        _bouquetsP = items;

      });
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

  _getPrice(String value)
  {

     _bouquets.forEach((Bouquet b)
     {
        if(b.bouquet == value)
        {
          _startPrice = int.parse(b.price);
          _price = _startPrice;

          if(_price <= 4000){
            service_fee = 100;
          }
          else if(_price > 4000 && _price <= 10000)
          {
            service_fee = 150;
          }
          else{
            service_fee = 200;
          }

          _showPrice(_price, service_fee);
          
        }
     });


  }

  _buildSubscribeForm(){
    return Form(
      key: _subscribeFormKey,
      child: Column(
        children: <Widget>[
          _buildIUCTF(),
          _buildPlanTF(),
          _plan != null ?
          _bouqs != null ?
          _buildBouquetTF() : Platform.isIOS
              ? new CupertinoActivityIndicator() : CircularProgressIndicator() : SizedBox.shrink(),
          _bouq != "Gotv Lite / Annually" && _bouq != "Gotv Lite / Quarterly" ?  _buildMonthsTF() : SizedBox.shrink(),
        ],
      ),

    );
  }


  _buildIUCTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(labelText: 'Smart Card/IUC Number'),
        validator: (input)=>
        input.trim().isEmpty || input.trim().length != 10 && input.trim().length != 11 ? 'Smart Card/IUC Number Must Be 10 Or 11 Digits':
        null,
        onSaved: (input)=>_iuc = input.trim(),

      ),
    );
  }

  _buildPlanTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 20.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _packages.map((String plan){
          return DropdownMenuItem(
            value: plan,
            child: Text(
              plan, style: TextStyle(
                color: Colors.black,
                fontSize: 15.0
            ),
            ),

          );
        }).toList(),
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            labelText: 'Brand',
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
        validator: (input)=>_plan == null
            ? "Please Select A Brand"
            : null,
        onChanged: (value)
        {
          setState(()
          {
            _bouqs = null;
            _plan = value;
            _getItemsPerBrand(_plan);


          });

        },
        value: _plan != null ? _plan : null,
      ),

    );
  }

  _buildBouquetTF()
  {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 15.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _bouqs.map((Bouquet bouquet)
        {

          return DropdownMenuItem(
            value: bouquet.bouquet,
            child: Text(
              bouquet.bouquet, style: TextStyle(
                color: Colors.black,
                fontSize: 12.0
            ),
            ),


          );
        }).toList(),
        style: TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
            labelText: 'Package',
            labelStyle: TextStyle(fontSize: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
        validator: (input)=>_bouq == null
            ? "Please Select A Package"
            : null,
        onChanged: (value)
        {
          setState(()
          {
            _bouq = value;
          });
          if(_bouq == "Gotv Lite / Quarterly")
          {
            setState(() {
              _months = ["4"];
              _month = "4";
              _getPrice(_bouq);


            });
          }
          else if(_bouq == "Gotv Lite / Annually"){

            setState(() {
              _months = ["12"];
              _month = "12";
              _getPrice(_bouq);

            });
          }
          else
            {
              setState(() {
                _months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
              });
            _getPrice(_bouq);
          }

          setState(() {
            if(_month == null){
              _month = '1';
            }
            else{
              _month = _month;
            }
          });
          _price = _price * int.parse(_month);
          if(_price <= 4000){
            service_fee = 100;
          }
          else if(_price > 4000 && _price <= 10000)
          {
            service_fee = 150;
          }
          else{
            service_fee = 200;
          }
          if(_month == '12' && _plan == "DStv")
          {

            setState(() {
              String mon = '11';
              _price = _startPrice * int.parse(mon);
            });
          }
          _showPrice(_price, service_fee);


        },
        value: _bouq != null ? _bouq: null,
      ),

    );
  }



   _showPrice(int price, int service)
   {

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 10.0),
      child: Container(


        child: Column(
          children: <Widget>[
            Center(child: Text("Total Amount: " + "NGN" +price.toString(), style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),),
            ),
            Center(child: Text("Service Fee: " + "NGN" +service.toString(), style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 8.0,
            ),),
            ),
          ],
        ),
      ),
    );
   }

  _buildMonthsTF(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 20.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _months.map((String month){
          return DropdownMenuItem(
            value: month,
            child: Text(
              month, style: TextStyle(
                color: Colors.black,
                fontSize: 15.0
            ),
            ),

          );
        }).toList(),
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            labelText: 'Month',
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
        validator: (input)=>_month == null
            ? "Please Select Month"
            : null,
        onChanged: (value)
        {
          setState(()
          {
            _month = value;
            _price = _startPrice;
            _price = _price * int.parse(_month);



          });
          if(_price <= 4000)
          {
            service_fee = 100;
          }
          else if(_price > 4000 && _price <= 10000)
          {
            service_fee = 150;
          }
          else{
            service_fee = 200;
          }
          if(_month == '12' && _plan == "DStv")
          {

            setState(() {
              String mon = '11';
              _price = _startPrice * int.parse(mon);
            });
          }
          _showPrice(_price, service_fee);

        },
        value: _month != null ? _month : null,
      ),

    );
  }



  _submit() async {
    if (!_subscribeFormKey.currentState.validate())
    {
      SizedBox.shrink();
    }

    else if (_isLoading == false)
    {
//      _scaffoldKey.currentState.showSnackBar(
//          new SnackBar(duration: new Duration(seconds: 3),
//            content:
//            new Row(
//              children: <Widget>[
//                Platform.isIOS
//                    ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
//                new Text("please wait...")
//              ],
//            ),
//          ));

      try
      {
        if (_subscribeFormKey.currentState.validate())
        {
          _subscribeFormKey.currentState.save();

          String type = "sub";
          String product;
          String brand;
          String number;
          Navigator.push(context, MaterialPageRoute(
            builder: (_) =>
                PaystackPay(price: _price.toString(),
                    email: _email,
                    type: type,
                    plan: _plan,
                    bouq: _bouq,
                    iuc: _iuc,
                    brand: brand,
                    product: product,
                    month: _month,
                    number: number),
          ));

//                  List res = await Provider.of<DatabaseService>(context, listen: false).addSubscription(_plan, _bouq,
//                      _month, _price.toString(), _iuc, _email);
//
//                  Map<String, dynamic> map;
//
//                  for(int i = 0; i < res.length; i++)
//                  {
//                    map = res[i];
//
//                  }
//
//                  if(map['status'] == "fail")
//                  {
//                    _showErrorDialog(map['msg'], map['status']);
//                  }
//                  else
//                  {
//                    _showErrorDialog(map['msg'], map['status']);
//                    if(mounted){
//                      setState(() {
//                        _isLoading = true;
//                      });
//                    }
//                  }



        }
      }
      on PlatformException catch (err) {
        _showErrorDialog(err.message, "error");
      }
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
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              ) : FlatButton(
                child: Text('Ok'),
                onPressed: ()=> Navigator.pop(context),
              )
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Center(child:
        Text('Subscribe', style: TextStyle(
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),

          ),
           Welcome(),
           _price == null ? SizedBox.shrink() : _showPrice(_price, service_fee),
          _buildSubscribeForm(),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: 180.0,
              child: Platform.isIOS ? CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Proceed To Payment', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,

                  ),
                  ),
                  onPressed: _submit
              ) : FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Proceed To Payment', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,

                  ),
                  ),
                  onPressed: _submit

              ),
            ),
          )
        ],
      ),
    );
  }
}
