import 'package:flutter/material.dart';


class DashBoard extends StatefulWidget {
  static String tag = 'dashboard';
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

//  logo
  Image appLogo = new Image(
      image: new ExactAssetImage("assets/logo.png"),
      height: 40.0,
      width: 40.0,
      alignment: FractionalOffset.center);

  final names = ['Michael Moses', 'Christine Hannah', 'Todd Tyson', 'Gift Johnson',
    'Michael Michelle', 'Justine Klopp', 'Tina Podolski', 'Doll Babyface', ];


  final images = ['assets/avatar.png','assets/avatar.jpg','assets/avatar.png','assets/avatar.jpg','assets/avatar.png','assets/avatar.jpg','assets/avatar.png','assets/avatar.jpg'];

  int _selectedItemIndex = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
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
    )
      ],
    ),
    ),

      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: EdgeInsets.all(20.0),
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Card( //
            margin: EdgeInsets.only(bottom: 12.0),//                <-- Card widget
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(images[index]),
              ),
              title: Text(names[index],
              style: TextStyle(
                color: Color.fromRGBO(42, 163, 237, 1),
                fontWeight: FontWeight.bold
              )
              ),
              trailing: Icon(Icons.arrow_forward_ios,color:Color.fromRGBO(42, 163, 237, 1),size: 15,),
              onTap: (){
                Navigator.pushReplacementNamed(context, 'user_details');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushReplacementNamed(context, 'new_user');
          },
          child: Icon(Icons.sort),
          foregroundColor: Color.fromRGBO(183, 15, 9, 1),
          backgroundColor: Colors.white


      ),
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
//          gradient: LinearGradient(colors: [
//            Color.fromRGBO(42, 163, 237, 1).withOpacity(0.3),
//            Color.fromRGBO(42, 163, 237, 1).withOpacity(0.015)
//          ],
//          begin: Alignment.bottomCenter,
//          end: Alignment.topCenter)
//            color: index == _selectedItemIndex? Colors.green : Colors.white
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
