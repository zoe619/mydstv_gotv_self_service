import 'dart:typed_data';

import 'package:eedc/data/utility.dart';
import 'package:eedc/route/form/form_profile_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eedc/services/database_helper.dart';
import 'package:eedc/model/billing.dart';


class BillList extends StatefulWidget
{
  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList>
{

  Future<List<Billing>> _billList;
  Uint8List _img;
  List<String> _result;
  Icon searchIcon = Icon(Icons.search, color: Colors.white);
  Widget titleBar = Text('My Bills',  style: TextStyle(
    color: Colors.white70,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),);

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  @override
  initState(){
    super.initState();
    _updateList();


  }



  _updateList(){
    setState(() {
      _billList = DatabaseHelper.instance.getBillList();

    });

  }
  _displayImage(Uint8List img){
    return GestureDetector(
      child: new ListTile(
        leading: Image.memory(img,
          fit: BoxFit.cover,
          width: 150.0,
          height: 50.0,
        ),
        onTap: ()async{
          await showDialog(
            context: context,
            builder: (_)=>ImageDialog(img),
          );
        },
        onLongPress: (){},

      ),

    );
  }

  Widget _buildTask(Billing bill)
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Title:'),
                Text(bill.title, style: TextStyle(
                  fontSize: 15.0,
                ),
                ),
                Text('Account no:'),
                Text(bill.customerAcct, style: TextStyle(
                  fontSize: 15.0,
                ),
                ),
              ],
             ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Bill Date:'),
                Text('${bill.readYear} /  ${bill.readMonth}', style: TextStyle(
                  fontSize: 15.0,
                ),
                ),
                Text('Readings:'),
                Text('${bill.currentRead} of  ${bill.previousRead}', style: TextStyle(
                  fontSize: 15.0,
                ),
                ),
              ],
            ),

          ),

          _displayImage(Utility.imageFromBase64String(bill.picture)),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      appBar:  AppBar(
          backgroundColor: Colors.blueGrey[400],
          title: Text("All Billings"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>FormProfileDataRoute()));
              },
            ),
          ]
      ),

      body: FutureBuilder(
          future: _billList,
          builder: (context, snapshot)
          {

            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }



            return  ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                itemCount: 1 + snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 100.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                        ],
                      ),
                    );
                  }
                  return _buildTask(snapshot.data[index -1]);
                }
            );

          }
      ),
    );
  }
}

class ImageDialog extends StatelessWidget
{

  final Uint8List _img;

  ImageDialog(this._img);
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      child: Container(

        child: ListTile(
          leading: Image.memory(_img,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 2,
          ),

        ),
      ),

    );
  }
}
