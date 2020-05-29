import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydstv_gotv_self_service/models/products.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:mydstv_gotv_self_service/models/user_data.dart';
import 'package:mydstv_gotv_self_service/screens/login_screen.dart';
import 'package:mydstv_gotv_self_service/screens/paystack_pay.dart';
import 'package:mydstv_gotv_self_service/screens/profile_screen.dart';
import 'package:mydstv_gotv_self_service/services/auth_service.dart';
import 'package:mydstv_gotv_self_service/services/database.dart';
import 'package:mydstv_gotv_self_service/widgets/nav_drawer.dart';
import 'package:mydstv_gotv_self_service/widgets/pop_dart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseItemDetails extends StatefulWidget
{

  final Products products;
  PurchaseItemDetails({this.products});
  @override
  _PurchaseItemDetailsState createState() => _PurchaseItemDetailsState();
}

class _PurchaseItemDetailsState extends State<PurchaseItemDetails>
{

  Products product_detail;
  String _selected;
  String _userId;
  User userData;
  List<String> _quantity = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"];
  String _number;
  int _price;
  bool _isLoading = false;
  String _product;
  String _brand;
  String _email;
  int service;


  final _purchaseFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product_detail = widget.products;
    _userId = Provider.of<UserData>(context, listen: false).currentUserId;
    _price = int.parse(widget.products.price);
    _brand = widget.products.brand;
    _product = widget.products.name;
    getUserData();

    if(_price <= 4000){
      service = 100;
    }
    else if(_price > 4000 && _price <= 10000)
    {
      service = 150;
    }
    else
      {
      service = 200;
    }

    _number = "1";

  }



  getUserData() async{
    User user = await Provider.of<DatabaseService>(context, listen: false).getUserWithId(_userId);
    setState(() {
      userData = user;
      _email = userData.email;
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
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          ModalRoute.withName('/'),
        );
      }

    });

  }

  _buildSubscribeForm()
  {
    return Form(
      key: _purchaseFormKey,
      child: Column(
        children: <Widget>[
          _buildQuantity(),

        ],
      ),

    );
  }

  _buildQuantity(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 5.0),

      child: DropdownButtonFormField(
        isDense: true,
        icon: Icon(Icons.arrow_drop_down_circle),
        iconSize: 15.0,
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _quantity.map((String quantity){
          return DropdownMenuItem
            (
            value: quantity,
            child: Text(
              quantity, style: TextStyle(
                color: Colors.black,
                fontSize: 10.0
            ),
            ),

          );
        }).toList(),
        style: TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
            labelText: 'select quantity',
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            )
        ),
        validator: (input)=>_number == null
            ? "please select quantity"
            : null,
        onChanged: (value)
        {
          setState(()
          {
            _number = value;
            _price = int.parse(widget.products.price);
            _price = _price * int.parse(_number);

            if(_price <= 4000){
              service = 100;
            }
            else if(_price > 4000 && _price <= 10000)
            {
              service = 150;
            }
            else
            {
              service = 200;
            }
            _showPrice(service);

          });


        },
        value: _number != null ? _number : null,
      ),

    );
  }




  _showPrice(int service)
  {

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 0.0),
      child: Container(

        child: Column(
          children: <Widget>[

            Center(child: Text("Service Fee: " + "NGN" +service.toString(), style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10.0,
            ),),
            ),
          ],
        ),
      ),
    );
  }
  _submit() async {
    if (!_purchaseFormKey.currentState.validate())
    {
      SizedBox.shrink();
    }

    else if (_isLoading == false)
    {
//      _scaffoldKey.currentState.showSnackBar(
//          new SnackBar(duration: new Duration(seconds: 5),
//            content:
//            new Row(
//              children: <Widget>[
//                Platform.isIOS
//                    ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
//                new Text("please wait...")
//              ],
//            ),
//          ));

      try {
        if (_purchaseFormKey.currentState.validate()) {
          _purchaseFormKey.currentState.save();

          String type = "buy";
          String bouq;
          String iuc;
          String plan;
          String month;
          Navigator.push(context, MaterialPageRoute(
            builder: (_) =>
                PaystackPay(price: _price.toString(),
                    email: _email,
                    type: type,
                    plan: plan,
                    bouq: bouq,
                    iuc: iuc,
                    brand: _brand,
                    product: _product,
                    month: month,
                    number: _number),
          ));

          //        List res = await Provider.of<DatabaseService>(context, listen: false).addPurchase(_brand, _product, _email,
          //            _number, _price.toString());
          //
          //        Map<String, dynamic> map;
          //
          //        for(int i = 0; i < res.length; i++)
          //        {
          //          map = res[i];
          //
          //        }
          //
          //        if(map['status'] == "fail")
          //        {
          //          _showErrorDialog(map['msg'], map['status']);
          //        }
          //        else
          //        {
          //          _showErrorDialog(map['msg'], map['status']);
          //          if(mounted){
          //            setState(() {
          //              _isLoading = true;
          //            });
          //          }
          //        }


        }
      }
      on PlatformException catch (error) {
        _showErrorDialog(error.message, "error");
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
                child: Text('ok'),
                onPressed: ()=>Navigator.pop(context),
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
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap:()async{
                await showDialog(
                  context: context,
                  builder: (_)=>ImageDialog(widget.products.pic),
                );
              },

            child: Stack(
              children: <Widget>[
                Image(
                  height: 220.0,
                  width: MediaQuery.of(context).size.width,
                  image: CachedNetworkImageProvider("https://mydstvgotvforselfservice.com/images/productimages/"+widget.products.pic),
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 70.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                    ],
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Product Name:', style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),),
                        Text(widget.products.name, style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                        ),),


                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Price:', style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),),
                        Text("NGN"+_price.toString(), style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                        ),),


                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Brand:', style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),),
                        Text(widget.products.brand, style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                        ),),


                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Discount:', style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        widget.products.discount == null ? 'N/A' : Text(widget.products.discount, style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                      ],
                    ),
                    _showPrice(service),
                  ],
                ),

                SizedBox(height: 6.0),

              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Platform.isIOS ? CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                color: Theme.of(context).primaryColor,

                child: Text(widget.products.brand, style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),

                ),
                onPressed: (){},
              ) : FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text(widget.products.brand, style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),

                ),
                onPressed: (){},
              ),

            ],
          ),
          Expanded(
             child:  _buildSubscribeForm(),
          ),

//          Center(
//            child: Text('', style: TextStyle(
//              fontSize: 22.0,
//              fontWeight: FontWeight.w600,
//              letterSpacing: 1.2,
//            ),
//            ),
//          ),
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(

              child: Platform.isIOS
                  ? new CupertinoButton(
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
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          image: CachedNetworkImageProvider("https://mydstvgotvforselfservice.com/images/productimages/"+_img),
          fit: BoxFit.cover,
        ),

      )

    );
  }
}


