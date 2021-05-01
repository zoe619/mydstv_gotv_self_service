import 'package:flutter/material.dart';

class ViewPrescription extends StatefulWidget {
  @override
  _ViewPrescriptionState createState() => _ViewPrescriptionState();
}

class _ViewPrescriptionState extends State<ViewPrescription> {
  int _selectedItemIndex = 2;
  @override
  Widget build(BuildContext context) {
    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);

    final presc =Container(
        padding:EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(242, 241, 241, 1)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.scatter_plot,color: Color.fromRGBO(112, 112, 112, 1)),
            Text('    '),
            Text('PARACETAMOL + PANADOLN + AMOXIL',style: TextStyle(
                color: Colors.black,fontSize: 10
            ),)

          ],
        ),
      );

    final pay = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: RaisedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'view_prescription');
              },
              color: Color.fromRGBO(42, 163, 237, 1),
              child: Text('Pay', style: TextStyle(color: Colors.white,fontSize: 20)),

            )
        ),
      ),
    );

    final cancel = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            margin:  EdgeInsets.only(left: 20,right: 90),
            child: RaisedButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'get_prescription');
              },
              color: Color.fromRGBO(171, 171, 171, 1),
              child: Text('Cancel', style: TextStyle(color: Colors.white,fontSize: 20)),

            )
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
            Text('Name: User',style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(height: 24.0),
            Text('Prescriptions',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
              SizedBox(height: 24.0),
              presc,
            SizedBox(height: 24.0),
            presc,
            SizedBox(height: 24.0),
            presc,
            SizedBox(height: 24.0),
            presc,
            SizedBox(height: 24.0),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  cancel,
                  pay
                ],
              )
            )
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
