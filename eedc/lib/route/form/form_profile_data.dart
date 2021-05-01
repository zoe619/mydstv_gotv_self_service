import 'dart:io';
import 'dart:typed_data';

import 'package:eedc/data/utility.dart';
import 'package:eedc/model/billing.dart';
import 'package:eedc/route/profile/bills.dart';
import 'package:eedc/services/database_helper.dart';
import 'package:eedc/services/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eedc/widget/my_text.dart';
import 'package:eedc/widget/toolbar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormProfileDataRoute extends StatefulWidget
{

  FormProfileDataRoute();

  @override
  FormProfileDataRouteState createState() => new FormProfileDataRouteState();
}


class FormProfileDataRouteState extends State<FormProfileDataRoute>
{

  File _image;
  Uint8List _img;
  String _url = "";
  bool _isLoading = false;
  String title,account,previous,current,month,year;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TextStyle textStyle = TextStyle(color: Colors.blueGrey[400], height: 1.4, fontSize: 16);
  TextStyle labelStyle = TextStyle(color: Colors.blueGrey[400]);
  UnderlineInputBorder lineStyle1 = UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[400], width: 1));
  UnderlineInputBorder lineStyle2 = UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[400], width: 2));

  _pickImageFromGallery()
  {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile)
    {
      setState(() => _image = imgFile);
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      setState(() {
        _url = imgString;
      });
    });
  }

  _displayChatImage()
  {
    return GestureDetector(
      onTap: _pickImageFromGallery,
      child: Center(
        child: CircleAvatar(
            radius: 80.0,
            backgroundColor: Colors.grey[300],
            backgroundImage: _image != null ? FileImage(_image) : null,
            child: _image == null ?
            const Icon(
              Icons.add_a_photo,
              size: 50.0,
            ): null

        ),
      ),
    );
  }

  _submit() async
  {

    try{
      if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();

        var now = new DateTime.now();
        var formatterYear = new DateFormat('yyyy');
        String year = formatterYear.format(now);

        var formatterMonth = new DateFormat('MM');
        String month = formatterMonth.format(now);

        setState(() {
          title = "zoe";

        });



//      insert task into sqflite database
        Billing bill = Billing(title:title, customerAcct: account, previousRead: previous, currentRead: current,
            readMonth: month, readYear: year, picture: _url);

        int res = await DatabaseHelper.instance.insertBill(bill);
        print(res);
        if(res != null)
        {
          _showErrorDialog('Billing Saved To Your Device', 'Success');

        }
        else{
          _showErrorDialog('Billing Not Saved', 'Error');

        }

      }
    } on PlatformException catch (err) {
      print(err);
    }


  }

  _submitApi() async
  {

    setState(() => _isLoading = false);

    if(!_formKey.currentState.validate())
    {
      SizedBox.shrink();
      return;
    }

    else if(_isLoading == false)
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
    try{
      if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();

        var now = new DateTime.now();
        var formatterYear = new DateFormat('yyyy');
        String year = formatterYear.format(now);

        var formatterMonth = new DateFormat('MM');
        String month = formatterMonth.format(now);



        bool response = await Server.addBIll(account, previous, current, month, year, _url);


        if(response)
        {
          _showErrorDialog('Billing Sent To Api', 'Success');

        }
        else{
          _showErrorDialog('Billing Not Sent To Api', 'Error');

        }

      }
    } on PlatformException catch (err) {
      print(err);
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
                onPressed: ()=>Navigator.pop(context),
              ) : FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);

                  }
              )
            ],
          );
        }
    );

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey[400],
          title: Text("Capture Billing"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>BillList()));
              },
            ),
          ]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 20),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      _displayChatImage(),
                        Container(height: 10),
                        TextFormField(
                          style: textStyle, keyboardType: TextInputType.text, cursorColor: Colors.pink[300],
                          decoration: InputDecoration(
                            labelText: "Account Number", labelStyle: labelStyle,
                            enabledBorder: lineStyle1, focusedBorder: lineStyle2,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "account required";
                            }
                            return null;
                          },
                          onSaved: (value) => account = value,
                        ),
                        Container(height: 10),
                        TextFormField(
                          style: textStyle, keyboardType: TextInputType.number, cursorColor: Colors.pink[300],
                          decoration: InputDecoration(
                            labelText: "Previous Read", labelStyle: labelStyle,
                            enabledBorder: lineStyle1, focusedBorder: lineStyle2,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "previous required";
                            }
                            return null;
                          },
                          onSaved: (value) => previous = value,
                        ),
                        Container(height: 10),
                        TextFormField(
                          style: textStyle, keyboardType: TextInputType.number, cursorColor: Colors.pink[300],
                          decoration: InputDecoration(
                            labelText: "Current Read", labelStyle: labelStyle,
                            enabledBorder: lineStyle1, focusedBorder: lineStyle2,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "current required";
                            }
                            return null;
                          },
                          onSaved: (value) => current = value,
                        ),
                        Container(height: 4),
                        Container(
                          width: 130,
                          height: 30,
                          child: FlatButton(
                              child: Text("Save On Phone",
                                style: TextStyle(color: Colors.black),),
                              color: Colors.blueGrey[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5)
                              ),
                              onPressed:_submit
                          ),
                        ),
                        Container(height: 10),
                        Spacer(),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: FlatButton(
                              child: Text("Submit",
                                style: TextStyle(color: Colors.black),),
                              color: Colors.green[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20)
                              ),
                              onPressed: _submitApi
                          ),
                        ),

                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
