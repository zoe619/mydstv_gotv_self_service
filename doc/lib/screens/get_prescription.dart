import 'package:flutter/material.dart';

class GetPrescription extends StatefulWidget {
  @override
  _GetPrescriptionState createState() => _GetPrescriptionState();
}

class _GetPrescriptionState extends State<GetPrescription> {
  //  logo

  int _selectedItemIndex = 2;
  @override
  Widget build(BuildContext context) {
    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);

    final presc =  Container(
        margin: EdgeInsets.only(left: 50,right: 40),
        child:  Text(
          "Get User's Prescription",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        )
    );

    final codebtn = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: RaisedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'view_prescription');
              },
              color: Color.fromRGBO(171, 171, 171, 1),
              child: Text('Get Code', style: TextStyle(color: Colors.white,fontSize: 20)),

            )
        ),
      ),
    );

    final code = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: new Icon(Icons.enhanced_encryption, color: Color.fromRGBO(42, 163, 237, 1)),
        hintText: 'Enter Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: <Widget>[
          buildNavBarItem(Icons.home,1,'dashboard'),
          buildNavBarItem(Icons.local_pharmacy,2,'get_prescription'),
          buildNavBarItem(Icons.supervised_user_circle,3,''),
          buildNavBarItem(Icons.settings,4,'')
        ],
      ),
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color.fromRGBO(182, 11, 5, 1),
            ),
            onPressed: () {
              // do something
            },
          )
        ],

        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),

      body: Center(
        child: ListView(
          shrinkWrap:true,
          padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            presc,
            SizedBox(height: 24.0),
            code,
            SizedBox(height: 24.0),
            codebtn

          ],
        ),
      ),
    );
  }
  Widget buildNavBarItem(IconData icon,int index,String page) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedItemIndex = index;
        });

        if(page != ''){
          Navigator.pushReplacementNamed(context, page);
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width/4,
        decoration:  index == _selectedItemIndex? BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2, color: Color.fromRGBO(42, 163, 237, 1))
          ),
        ) : BoxDecoration(),
        child: Icon(
            icon,
            size: 20,
            color:  index == _selectedItemIndex? Color.fromRGBO(42, 163, 237, 1) : Colors.grey)
        ,
      ),
    );
  }
}

