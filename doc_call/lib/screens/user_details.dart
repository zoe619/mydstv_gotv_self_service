import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/patient.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/login_page.dart';
import 'package:doc_call/screens/patient_screen.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:doc_call/widgets/pop_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();

  Client client;
  String email,name;
  UserDetails({this.client, this.email, this.name});
}

class _UserDetailsState extends State<UserDetails>
{

  int _selectedItemIndex = 1;

  int display = 0;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name, email, phone, age, prescription, doc_email, doc_name, image, _type;
  final myController = TextEditingController();

  bool _isLoading = false;
  User userData;
  List<Patient> pats;
  String _selected;
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
//    getUserData();
    print(widget.email + " "+ widget.name);

  }



  getPatientData() async
  {


    List<Patient> pat = await Provider.of<DatabaseService>(context, listen: false).getPatient(widget.client.email, widget.email);
    if(mounted)
    {
      setState(() {
        pats = pat;
      });
    }

  }

  File _image;

  _handleImageFromGallery() async
  {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      setState(()
      {
        _image = File(pickedFile.path);
          myController.text;
      });
    }

  }

  _displayProfileImage()
  {
     if(_image != null)
     {
       return FileImage(_image);
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
                child: Text('ok'),
                onPressed: ()=>Navigator.pop(context),
              ) : FlatButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.pop(context);

                  }
              )
            ],
          );
        }
    );

  }

  _goTo(){
    Navigator.push(context, MaterialPageRoute
      (
      builder: (_)=>PatientScreen(doc: widget.email, patient: widget.client.email, type: "doc")
    ));
  }

  void choiceAction(PopUp pop)
  {

    setState(()
    {
      _selected = pop.option;

      if(_selected == 'profile')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>ProfileScreen(userId: widget.email, type: "doc"),
        ));


      }
      else if(_selected == 'home')
      {
        Navigator.push(context, MaterialPageRoute(
          builder: (_)=>HomeScreen(email: widget.email, type:"doc"),
        ));

      }
      else if(_selected == 'sms')
      {

      }
      else if(_selected == 'log_out')
      {

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
        );
      }

    });

  }


  _submit() async
  {

    if(widget.name == null || widget.email == null)
    {
      _showErrorDialog("You Need To Update Your Profile Information To Proceed", "Error");
      SizedBox.shrink();
      return;
    }
    if(_isLoading == false)
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(duration: new Duration(seconds: 2),
            content:
            new Row(
              children: <Widget>[
                Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                new Text("please wait...")
              ],
            ),
            action: new SnackBarAction(
                label: 'OK',
                onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
          ));
    }
    try
    {
      if(!_isLoading)
      {
          _formKey.currentState.save();



          final dbService = Provider.of<DatabaseService>(context, listen: false);

          if(_image != null)
          {
              List res = await dbService.prescription(widget.client.names, widget.client.email, widget.client.phone,
                widget.client.age, prescription, widget.name, widget.email,_image);
              Map<String, dynamic> map;


              for(int i = 0; i < res.length; i++)
              {
                map = res[i];

              }
              if(map['status'] == "fail")
              {
                _showErrorDialog(map['msg'], map['status']);

              }
              else
              {

                Navigator.pop(context);
              }

          }
          else
            {
            List res = await dbService.prescription2(widget.client.names, widget.client.email, widget.client.phone,
                widget.client.age, prescription, widget.name, widget.email);
            Map<String, dynamic> map;


            for(int i = 0; i < res.length; i++)
            {
              map = res[i];

            }
            if(map['status'] == "fail")
            {
              _showErrorDialog(map['msg'], map['status']);

            }
            else
            {

               Navigator.pop(context);
            }
          }


      }

    }
    on PlatformException catch (err) {
      _showErrorDialog(err.message, "Failed");
    }

  }

  _buildPresTF()
  {
    return Container(
      width: 330,
      child: TextFormField(
//        initialValue: prescription.isNotEmpty ? prescription : "empty",
          controller: myController,
          keyboardType: TextInputType.text,
          maxLines: 4,
          autofocus: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
          ),
          validator: (input)=>
          input.isEmpty ? 'Please Enter Prescription' : null,
          onSaved: (input){
            prescription = input;
          },
          onEditingComplete: () {
          prescription = myController.text;
          setState(() {
            prescription = myController.text;
          });
        },
      ),
    );
  }

  _displayImage()
  {
    return GestureDetector(
      onTap:()async
      {
        _image != null ?
        await showDialog(
          context: context,
          builder: (_)=>ImageDialog(_image),
        ) : SizedBox.shrink();
      },
      child: CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.grey,
        backgroundImage: _displayProfileImage(),
      ),
    );
  }

  _buildPic()
  {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: GestureDetector(
        child: Container(
          height: 25,
          child: RaisedButton.icon(
              onPressed: (){
                _handleImageFromGallery();

              },

              icon: new Icon(Icons.file_upload, color: Color.fromRGBO(171, 171, 171, 1)),
              color: Colors.white,
              shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromRGBO(171, 171, 171, 1),width: 1.0),borderRadius: BorderRadius.circular(20)),
              label: Text('Upload Snap Prescriptions', style: TextStyle(color: Color.fromRGBO(171, 171, 171, 1)),
              )
          ),

        ),

      ),
    );

  }

  _buildPresForm()
  {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildPic(),
          SizedBox(height: 10.0),
          _buildPresTF(),
        ],
      ),

    );
  }


  _buildItems()
  {
    List<Widget> presList = [];
    pats == null ? Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator() :
    pats.forEach((Patient pat){
      presList.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding:EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color.fromRGBO(112, 112, 112, 1)
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(pat.prescription_date,style: TextStyle(
                      color: Colors.white,fontSize: 10
                  ),),
                  Text('    '),
                  Expanded(
                    child: Text(pat.prescription,style: TextStyle(
                        color: Colors.white,fontSize: 10
                    ),),
                  ),
                  pat.picture != null ?
                  GestureDetector(
                    child: Container(
                      height: 40.0,
                      width: 50.0,
                      child: Image.network(
                        'https://doctor-on-call247.com/pizza/'+pat.picture,
                      ),
                    ),
                    onTap:()async
                    {

                      await showDialog(
                      context: context,
                      builder: (_)=>ImageDialog2('https://doctor-on-call247.com/pizza/'+pat.picture),
                      );
                    },
                  ): SizedBox.shrink()
                ],

              ),

            ),
        ),

        );
      });

    return Column(
        children: presList
    );


  }


  @override
  Widget build(BuildContext context)
  {


    final submit = Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        height: 60,
        width: 200.0,
        child: RaisedButton(
            onPressed: _submit,
            color: Colors.white,
            shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromRGBO(171, 171, 171, 1),width: 1.0),borderRadius: BorderRadius.circular(20)),
          child: Text('SUBMIT', style: TextStyle(color: Color.fromRGBO(42, 163, 237, 1)),)

        ),
      ),
    );

    final submitP = Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        height: 30,
        width: 150.0,
        child: RaisedButton(
            onPressed: _goTo,
            color: Colors.white,
            shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromRGBO(171, 171, 171, 1),width: 1.0),borderRadius: BorderRadius.circular(20)),
            child: Text('Edit Patient Data', style: TextStyle(color: Color.fromRGBO(42, 163, 237, 1)),)

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
          key: _scaffoldKey,
            bottomNavigationBar: Row(
              children: <Widget>[

              ],
            ),
            appBar: AppBar(
              title: appLogo,
              actions: <Widget>[
                new PopupMenuButton(
                  itemBuilder: (BuildContext context){
                    return PopUp.pop.map((PopUp pop){
                      return new PopupMenuItem(
                        value: pop,

                        child: new ListTile(
                          title: pop.title,
                          leading: pop.icon,
                        ),

                      );

                    }).toList();
                  },
                  onSelected: choiceAction,
                ),
              ],

              backgroundColor: Colors.white,
              iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

            ),

            backgroundColor: Colors.white,
            body: Center(
              child: FutureBuilder(
                future: getPatientData(),
                builder: (BuildContext context, AsyncSnapshot snapshot)
                {

                  return ListView(
                    shrinkWrap:true,
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.only(left: 24.0, right: 24.0),
                      ),
                      Column(
                        children: <Widget>[

                          _displayImage(),
                          SizedBox(height: 40.0),
                          SizedBox(height: 10.0),
                          _buildPresForm(),
                          SizedBox(height: 20.0),
                          submit,
                          SizedBox(height: 40.0),
                          Text('Previous Prescriptions'),
                          SizedBox(height: 10.0),
                          submitP,
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildItems(),
                        ],
                      )
                    ],
                  );
                },

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

class ImageDialog extends StatelessWidget
{

  final File _img;

  ImageDialog(this._img);
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 2,
          child: Image(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            image: FileImage(_img),
            fit: BoxFit.cover,
          ),

        )

    );
  }
}


class ImageDialog2 extends StatelessWidget
{

  final String pic;

  ImageDialog2(this.pic);
  @override
  Widget build(BuildContext context)
  {
    return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 2,
          child: Image.network(pic),

        )

    );
  }
}
