import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/user_data.dart';
import 'package:doc_call/screens/home_screen.dart';
import 'package:doc_call/screens/profile_screen.dart';
import 'package:doc_call/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
  User user;
  EditProfile({this.user});
}

class _EditProfileState extends State<EditProfile>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _editFormKey = GlobalKey<FormState>();
  String name, email, phone, user_type, license, company, address, code, url;
  bool _isLoading = false;
  int group = 0;


  File _image;
  File _profileImage;
  @override
  void initState()
  {
    super.initState();
    phone = widget.user.phone;
    name = widget.user.name;
    license = widget.user.license;
    email = widget.user.email;
    user_type = widget.user.type;
    company = widget.user.company;
    address = widget.user.address;
    code = widget.user.code;
    url = widget.user.imageUrl;


  }

  Future<void> _pickImage(ImageSource source) async
  {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = selected;
    });
  }

  void _clear(){
    setState(() => _image = null);
  }

  Future<void> _cropImage()async{
    File cropped = await ImageCropper.cropImage(
        sourcePath: _image.path
    );

    setState(() {
      _image = cropped ?? _image;
    });
  }

  int _selectedItemIndex = 1;

//  _handleImageFromGallery() async
//  {
//    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if (imageFile != null) {
//      setState(() {
//        _profileImage = imageFile;
//      });
//    }
//  }


    _handleImageFromGallery() async
    {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if(pickedFile != null)
      {
        setState(()
        {
          _profileImage = File(pickedFile.path);

        });
      }

    }

  _displayProfileImage()
  {
    //No new profile image
    if(_profileImage == null)
    {
      //No existing profile image
      if(widget.user.imageUrl == null)
      {
        return AssetImage('assets/avatar.png');
      }
//         user profile image exist
      else{
        return CachedNetworkImageProvider("https://doctor-on-call247.com/pizza/"+widget.user.imageUrl);
      }
    }
    //New profile image
    else
    {
      return FileImage(_profileImage);
    }

  }

  @override
  Widget build(BuildContext context)
  {



//    final avatar = GestureDetector(
//      onTap: (){
//        _pickImage(ImageSource.gallery);
//      },
//
//      child: CircleAvatar(
//        backgroundColor: Colors.transparent,
//        radius: 48.0,
//        child: _image == null
//            ? Image.asset('assets/avatar.png')
//            : Image.file(_image),
//
//      ),
//    );
    _buildEmailTF(){
      return TextFormField(
        initialValue: email,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.email, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Email Address',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
          validator: (input)=>
          !input.contains('@') ? 'Please Enter A Valid Email' : null,
          onSaved: (input)=>email = input,
      );
    }

    _buildNameTF()
    {
      return TextFormField(
        initialValue: name,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.supervised_user_circle, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Full Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A Valid Name' : null,
        onSaved: (input)=> name = input,
      );
    }


    _buildPhoneTF()
    {
      return TextFormField(
        initialValue: phone,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.phone, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Phone Number',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'please enter a valid phone number' : null,
        onSaved: (input)=>phone = input,
      );
    }

    _buildLicenseTF(){
      return TextFormField(
        initialValue: license,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'License',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter A License Number' : null,
        onSaved: (input)=> license = input,
      );
    }

    _buildCompanyTF(){
      return TextFormField(
        initialValue: company,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Company',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter Company Name' : null,
        onSaved: (input)=> company = input,
      );
    }

    _buildAddressTF(){
      return TextFormField(
        initialValue: address,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.verified_user, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Address',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? 'Please Enter Address' : null,
        onSaved: (input)=> address = input,
      );
    }

    _buildCodeTF()
    {
      return TextFormField(
        initialValue: code,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: new Icon(Icons.phone, color: Color.fromRGBO(42, 163, 237, 1)),
          hintText: 'Master Agent Code',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        validator: (input)=> input.trim().isEmpty ? null : null,
        onSaved: (input)=>code = input,
      );
    }



    _buildEditForm()
    {
      return Form(
        key: _editFormKey,
        child: Column(
          children: <Widget>[
            user_type == "agent" ? GestureDetector(
              onTap: _handleImageFromGallery,
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage: _displayProfileImage(),
              ),
            ) : SizedBox.shrink(),
            SizedBox(height: 10.0),
            _buildEmailTF(),
            SizedBox(height: 10.0),
            _buildNameTF(),
            SizedBox(height: 10.0),
            _buildPhoneTF(),
            SizedBox(height: 10.0),
            user_type == "doc" ? _buildLicenseTF() : SizedBox.shrink(),
            user_type == "agent" ? _buildCompanyTF() : SizedBox.shrink(),
            SizedBox(height: 10.0),
            user_type == "agent" ? _buildAddressTF() : SizedBox.shrink(),
            SizedBox(height: 10.0),
            user_type == "agent" ? _buildCodeTF() : SizedBox.shrink(),
          ],
        ),

      );
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

    _submit() async
    {

      setState(() => _isLoading = false);


      if(!_editFormKey.currentState.validate())
      {
        SizedBox.shrink();
      }


      else if(_isLoading == false)
      {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(duration: new Duration(seconds: 60),
              content:
              new Row(
                children: <Widget>[
                  Platform.isIOS
                      ? new CupertinoActivityIndicator() : new CircularProgressIndicator(),
                  new Text("please wait...")
                ],
              ),
              action: new SnackBarAction(
                  label: 'OK',
                  onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
            ));



      }

      final dbService = Provider.of<DatabaseService>(context, listen: false);

      try
      {

        if(_editFormKey.currentState.validate())
        {
          _editFormKey.currentState.save();


          if(user_type == "agent")
          {
            company = company;
            address = address;
            license = "nill";
            code = code;

            if (_profileImage != null)
            {
                  List res = await dbService.updateAgent(
                      name,
                      email,
                      phone,
                      company,
                      address,
                      code,
                      user_type,
                      _profileImage);
                  Map<String, dynamic> map;

                  for (int i = 0; i < res.length; i++) {
                    map = res[i];
                  }

                  if (map['status'] == "fail") {
                    _showErrorDialog(map['msg'], map['status']);
                  }
                  else
                    {
//                    if (_profileImage == null) {
//                      url = widget.user.imageUrl;
//                    }
//                    else {
//                      url = await StorageService.uploadUserProfileImage(
//                          widget.user.imageUrl,
//                          _profileImage);
//                    }
//
//                    // update user in firebase
//                    User user = User(
//                        id: widget.user.id,
//                        email: email,
//                        phone: phone,
//                        name: name,
//                        license: license,
//                        company: company,
//                        address: address,
//                        code: code,
//                        imageUrl: url
//                    );
//
//                    DatabaseService.updateUserFirebase(user);
                    Navigator.pop(context);
                  }
                }
              else
                {
              List res = await dbService.updateAgent2(
                  name,
                  email,
                  phone,
                  license,
                  company,
                  address,
                  code,
                  user_type
                  );
              Map<String, dynamic> map;

              for (int i = 0; i < res.length; i++) {
                map = res[i];
              }

              if (map['status'] == "fail") {
                _showErrorDialog(map['msg'], map['status']);
              }
              else {

//                  url = widget.user.imageUrl;
//
//
//
//                    // update user in firebase
//                    User user = User(
//                    id: widget.user.id,
//                    email: email,
//                    phone: phone,
//                    name: name,
//                    license: license,
//                    company: company,
//                    address: address,
//                    code: code,
//                    imageUrl: url
//                );
//
//                DatabaseService.updateUserFirebase(user);
                Navigator.pop(context);
              }
              }
          }
          else
            {


            if (user_type == "doc") {
              license = license;
              company = "nill";
              address = "nill";
              code = "nill";
              url = "nill";
            }
            else if (user_type == "pharm")
            {
              license = "nill";
              company = "nill";
              address = "nill";
              code = "nill";
              url = "nill";
            }



            List res = await dbService.updateProfile(
                name,
                email,
                phone,
                license,
                user_type,
                company,
                address);
            Map<String, dynamic> map;

            for (int i = 0; i < res.length; i++)
            {
              map = res[i];
            }

            if (map['status'] == "fail") {
              _showErrorDialog(map['msg'], map['status']);
            }
            else
              {
                Navigator.pop(context);

              // update user in firebase
//              User user = User(
//                  id: widget.user.id,
//                  email: email,
//                  phone: phone,
//                  name: name,
//                  license: license,
//                  company: company,
//                  address: address,
//                  code: code,
//                  imageUrl: url
//              );
//
//              DatabaseService.updateUserFirebase(user);
//              Navigator.pop(context);
//
//              setState(() {
//                _isLoading = true;
//              });
            }
          }
        }
      }
      on PlatformException catch (err)
      {
        _showErrorDialog(err.message, "error");
      }



    }

    final loginButton = Padding(
      padding: EdgeInsets.all(0.0),
      child: ClipRect(
        child: Container(
            height: 60,
            child: RaisedButton(
              onPressed: _submit,
              color: Color.fromRGBO(171, 171, 171, 1),
              child: Text('Submit', style: TextStyle(color: Colors.white),),
            )
        ),
      ),
    );

    Image appLogo = new Image(
        image: new ExactAssetImage("assets/logo.png"),
        height: 40.0,
        width: 40.0,
        alignment: FractionalOffset.center);


    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
        children: <Widget>[
//          user_type == "doc" ? buildNavBarItem(Icons.home,1,'dashboard') : SizedBox.shrink(),
//          user_type == "pharm" ? buildNavBarItem(Icons.local_pharmacy,2,'get_prescription') : SizedBox.shrink(),
//          user_type == "agent" ? buildNavBarItem(Icons.home,3,'') : SizedBox.shrink(),
//          buildNavBarItem(Icons.settings,4,'')
        ],
      ),
      appBar: AppBar(
        title: appLogo,
        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.notifications,
//              color: Color.fromRGBO(182, 11, 5, 1),
//            ),
//            onPressed: () {
//              // do something
//            },
//          )
        ],

        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Color.fromRGBO(42, 163, 237, 1) ),

      ),
      body: Center(
        child: ListView(
          shrinkWrap:true,
          padding:EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text('Profile Update',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 30,),),
            SizedBox(height: 20.0),
//            avatar,
            SizedBox(height: 48.0),
            _buildEditForm(),
            SizedBox(height: 24.0),
            loginButton
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
        if(_selectedItemIndex == 1)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>HomeScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId),
          ));

        }

        else if(_selectedItemIndex == 4)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>ProfileScreen(userId: widget.user.id),
          ));

        }
        else if(_selectedItemIndex == 3)
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=>HomeScreen(userId: Provider.of<UserData>(context, listen: false).currentUserId),
          ));

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

