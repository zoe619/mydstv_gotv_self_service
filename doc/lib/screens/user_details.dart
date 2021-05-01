import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  int _selectedItemIndex = 1;
  @override
  Widget build(BuildContext context) {



    final desc = TextFormField(
      keyboardType: TextInputType.text,
      maxLines: 8,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );

    final btn = Padding(
      padding: EdgeInsets.all(0.0),
        child: Container(
            height: 60,
            child: RaisedButton.icon(
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'dashboard');
              },icon: new Icon(Icons.file_upload, color: Color.fromRGBO(171, 171, 171, 1)),
              color: Colors.white,
              shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromRGBO(171, 171, 171, 1),width: 1.0),borderRadius: BorderRadius.circular(20)),
              label: Text('Upload Snap Prescriptions', style: TextStyle(color: Color.fromRGBO(171, 171, 171, 1)),
            )
        ),
      ),
    );

    final submit = Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        height: 60,
        child: RaisedButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, 'dashboard');
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromRGBO(171, 171, 171, 1),width: 1.0),borderRadius: BorderRadius.circular(20)),
          child: Text('SUBMIT', style: TextStyle(color: Color.fromRGBO(42, 163, 237, 1)),)

        ),
      ),
    );

    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);


    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
              bottom: TabBar(
                labelColor: Color.fromRGBO(42, 163, 237, 1),
                indicator: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1.0,color: Color.fromRGBO(42, 163, 237, 1)))
                ),
                tabs: <Widget>[
                  Tab(
                    text: 'LIST OF PATIENTS',

                  ),
                  Tab(
                      text: 'USERNAME'
                  )
                ] ,
              ),
            ),

            backgroundColor: Colors.white,
            body: Center(
              child: ListView(
                shrinkWrap:true,
                padding:EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Text('Prescriptions'),
                  SizedBox(height: 10.0),
                  desc,
                  SizedBox(height: 20.0),
                  btn,
                  SizedBox(height: 20.0),
                  submit,
                  SizedBox(height: 40.0),
                  Text('Former Prescriptions'),
                  SizedBox(height: 20.0),
                  Container(
                    padding:EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromRGBO(112, 112, 112, 1)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('24-02-20',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),),
                        Text('    '),
                        Text('PARACETAMOL + PANADOLN + AMOXIL',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),)

                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding:EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromRGBO(145, 145, 145, 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('24-02-20',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),),
                        Text('    '),
                        Text('PARACETAMOL + PANADOLN + AMOXIL',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),)

                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding:EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromRGBO(168, 168, 168, 1)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('24-02-20',style: TextStyle(
                          color: Colors.white,fontSize: 10
                        ),),
                        Text('    '),
                        Text('PARACETAMOL + PANADOLN + AMOXIL',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),)

                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding:EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromRGBO(191, 191, 191, 1)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('24-02-20',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),),
                        Text('    '),
                        Text('PARACETAMOL + PANADOLN + AMOXIL',style: TextStyle(
                            color: Colors.white,fontSize: 10
                        ),)

                      ],
                    ),
                  )
                ],
              ),
            )
        )
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
