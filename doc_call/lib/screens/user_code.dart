import 'package:flutter/material.dart';

class UserCode extends StatefulWidget {
  @override
  _UserCodeState createState() => _UserCodeState();
}

class _UserCodeState extends State<UserCode> {
  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero1',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset(
          'assets/logo.png',
          width: 50,
          height: 50,
        ),

      ),
    );

    final avatar = Hero(
      tag: 'avatar',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset(
          'assets/avatar.png'
        ),

      ),
    );

    final txt =  Container(
        margin: EdgeInsets.only(left: 120,right: 40),
        child:  Text(
          'Your Code',
          style: TextStyle(
              color: Color.fromRGBO(42, 163, 237, 1),
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),
        )
    );

    final code =  Container(
      margin: EdgeInsets.only(left: 80,right: 40),
      child:  Text(
          '0 0 0 0',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 50
          ),
        )
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap:true,
          padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            Container(
              margin: EdgeInsets.only(left: 80,right: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Doc On',
                    style: TextStyle(
                        color: Color.fromRGBO(42, 163, 237, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  ),
                  Text(
                    ' Call',
                    style: TextStyle(
                        color: Color.fromRGBO(183, 15, 9, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  )


                ],
              ),
            ),
            SizedBox(height: 28.0),
            Container(
              margin: EdgeInsets.only(left: 100,right: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Hello,',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                  Text(
                    ' Username',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  )


                ],
              ),
            ),

            SizedBox(height: 20.0),
            avatar,
            SizedBox(height: 25.0),
            txt,
            SizedBox(height: 20.0),
            code,

          ],
        ),
      ),
    );
  }
}
