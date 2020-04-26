import 'package:flutter/material.dart';
import 'package:mydstv_gotv_self_service/models/fcm_model.dart';


class FcmScreen extends StatelessWidget
{

  final List<FcmModel> list;

  FcmScreen({this.list});

  _buildNotification(BuildContext context, FcmModel msg)
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
                          child: Text("Micgrand Inc", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 4.0),

                        SizedBox(height: 4.0),
                        Text("notification", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 15.0),
                        Flexible(
                          child: msg.message == null ? SizedBox.shrink() : Text(msg.message, style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                              color: Theme.of(context).primaryColor
                          ),

                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
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
                image: AssetImage("assets/images/notification.png"),
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
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 20.0),
//          child: Text('Micgrand Inc', style: TextStyle(
//            fontSize: 24.0,
//            fontWeight: FontWeight.w600,
//            letterSpacing: 1.2,
//          ),
//          ),
//        ),
        Container(
          height: 120.0,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.vertical,
              itemCount:  null == list ? 0 : list.length,
              itemBuilder: (BuildContext context, int index)
              {
                FcmModel messages = list[index];
                return _buildNotification(context, messages);
              }),
        ),

      ],
    );
  }
}
