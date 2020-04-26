import 'package:flutter/material.dart';
import 'package:mydstv_gotv_self_service/models/activities.dart';

class ActivityScreen extends StatefulWidget
{
  final Activity activity;
  ActivityScreen({this.activity});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                tag: widget.activity.imageUrl,
                child: Image(
                  height: 220.0,
                  width: MediaQuery.of(context).size.width,
                  image: AssetImage(widget.activity.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 70.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: ()=> Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      iconSize: 35.0,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){},
                    )
                  ],
                ),
              ),

            ],
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.activity.name, style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                    ),),
                    Text('o.2 miles away', style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600
                    ),)
                  ],
                ),

                SizedBox(height: 6.0),
                Text(widget.activity.address, style: TextStyle(
                  fontSize: 18.0,
                ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text('Reviews', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),

                ),
                onPressed: (){},
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text('Contacts', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),

                ),
                onPressed: (){},
              )
            ],
          ),
          Center(
            child: Text('Menu', style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
            ),
          ),
          SizedBox(height: 10.0),
//          Expanded(
//            child: GridView.count(
//              padding: EdgeInsets.all(10.0),
//              crossAxisCount: 2,
//              children: List.generate(widget.activity.menu.length, (index){
//                Food food = widget.restaurant.menu[index];
//                return _buildMenuItem(food);
//              }),
//            ),
//          )
        ],
      ),
    );
  }
}
