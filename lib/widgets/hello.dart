import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Hello extends StatelessWidget
{

  final DateTime date = DateTime.now();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy').add_jm();




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
                        Text("What a good day to be alive!", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),

                        SizedBox(height: 4.0),
                        Text(_dateFormatter.format(date), style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                          overflow: TextOverflow.ellipsis,
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
  Widget build(BuildContext context) {
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
