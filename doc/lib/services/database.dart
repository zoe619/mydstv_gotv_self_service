import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_pass/models/history.dart';
import 'package:covid_pass/models/mobileuser.dart';
import 'package:covid_pass/models/user.dart';
import 'package:covid_pass/utilities/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:dio/dio.dart';



class DatabaseService
{



  Future<List<History>> getTransaction(String email)async
  {

    var map = Map<String, dynamic>();

    map['email'] = email;

    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/get-covid.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<History> list = parseResponseTransact(response.body);
        return list;
      }
      else{
        return  List<History>();
      }

    }
    catch(err){
      return List<History>();
    }
  }

  List<History> parseResponseTransact(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<History>((json)=> History.fromJson(json)).toList();

  }



  static checkLogin()async
  {
    String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/checklogin.php";
    var res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var result = json.decode(res.body);


    return result;
  }





  static User parseResponseSingle(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>();
    return parsed.map<User>((json)=> MobileUser.fromJson(json)).toList();

  }

  addUser(String name, String email, String phone, String password, String address, String type, String rc)async{
    try{
      var map = Map<String, dynamic>();
      map['names'] = name;
      map['email'] = email;
      map['password'] = password;
      map['phone'] = phone;
      map['address'] = address;
      map['type'] = type;
      map['rc'] = rc;
      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/add-covid.php";
      http.Response res = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(res.statusCode == 200)
      {
        List result = json.decode(res.body);

        return result;
      }
      else{
        var error = json.decode(res.body);
        return error;
      }

    }
    catch(err){
      return err.toString();
    }
  }


  request(String email, String destination, String reason, String route, String hours, String type, String person)async{
    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['destination'] = destination;
      map['reason'] = reason;
      map['route'] = route;
      map['hours'] = hours;
      map['person'] = person;
      map['type'] = type;
      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/request-covid.php";
      http.Response res = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(res.statusCode == 200)
      {
        List result = json.decode(res.body);

        return result;
      }
      else{
        var error = json.decode(res.body);
        return error;
      }

    }
    catch(err){
      return err.toString();
    }
  }



  upload(String email, String address, String phone, File file) async
  {


     String fileName = file.path.split('/').last;


     try{
       FormData formData = new FormData.fromMap({
        "email": email,
         "address": address,
         "phone": phone,
         "file": await MultipartFile.fromFile(file.path, filename: fileName)
       });

       Response response = await Dio().post("https://mydstvgotvforselfservice.com/new_mobile/pizza/update-covid.php",
         data: formData,
       );

       print("response from server: $response");
       if(response.statusCode == 200)
       {
         List result = json.decode(response.data);
         print("list: $result");

         return result;
       }
       else {
         List error = json.decode(response.data);
         print("error: $error");

         return error;
       }
     }
     catch(e){
       print("Caught exception $e");

     }


  }


  //   function to retrieve user from firestore based on userId
  Future<User> getUser(String userId) async
  {

    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    return User.fromDoc(userDoc);
  }


  Future<Map<String, dynamic>> getUserDetails(String id) async{
    User user = await getUser(id);
    Map<String, dynamic> userMap =
    {
      'name': user.name,
      'email': user.email,
      'phone': user.phone
    };
    return userMap;
  }

  //   function to retrieve user from firestore based on userId
  Future<User> getUserWithId(String userId) async
  {
    DocumentSnapshot userDocSnapshot = await usersRef.document(userId).get();
    if(userDocSnapshot.exists)
    {
      return User.fromDoc(userDocSnapshot);
    }
    return User();

  }

  static void updateUserFirebase(User user)
  {
    usersRef.document(user.id).updateData({
      'address' : user.address,
      'phone': user.phone,
      'url': user.url
    });
  }












}
