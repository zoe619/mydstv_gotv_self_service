import 'dart:convert';
import 'dart:io';


import 'package:doc_call/models/User.dart';
import 'package:doc_call/models/client.dart';
import 'package:doc_call/models/doctor.dart';
import 'package:doc_call/models/history.dart';
import 'package:doc_call/models/mobileuser.dart';
import 'package:doc_call/models/patient.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:dio/dio.dart';




class DatabaseService
{



  Future<List<Client>> getClient(String email)async
  {

    var map = Map<String, dynamic>();

    map['email'] = email;

    try{

      String url = "https://doctor-on-call247.com/pizza/getItem.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Client> list = parseResponseClient(response.body);

        return list;
      }
      else{
        return  List<Client>();
      }

    }
    catch(err){
      return List<Client>();
    }
  }

  List<Client> parseResponseClient(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Client>((json)=> Client.fromJson(json)).toList();

  }

  Future<List<Client>> getClient2(String email, String pat)async
  {

    var map = Map<String, dynamic>();

    map['doc_email'] = email;
    map['pat_email'] = pat;

    try{

      String url = "https://doctor-on-call247.com/pizza/getSingleItem.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Client> list = parseResponseClient2(response.body);

        return list;
      }
      else{
        return  List<Client>();
      }

    }
    catch(err){
      return List<Client>();
    }
  }

  List<Client> parseResponseClient2(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Client>((json)=> Client.fromJson(json)).toList();

  }



  Future<List<Patient>> getPatient(String p_email, String doc_email)async
  {

    var map = Map<String, dynamic>();

    map['p_email'] = p_email;
    map['doc_email'] = doc_email;


    try{

      String url = "https://doctor-on-call247.com/pizza/getPatient.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Patient> list = parseResponsePatient(response.body);

        return list;
      }
      else{
        return  List<Patient>();
      }

    }
    catch(err){
      return List<Patient>();
    }
  }

  List<Patient> parseResponsePatient(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Patient>((json)=> Patient.fromJson(json)).toList();

  }





  Future<List<Patient>> getPatient2(String code)async
  {

    var map = Map<String, dynamic>();

    map['code'] = code;


    try{

      String url = "https://doctor-on-call247.com/pizza/getPatient.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Patient> list = parseResponsePatient(response.body);

        return list;
      }
      else{
        return  List<Patient>();
      }

    }
    catch(err){
      return List<Patient>();
    }
  }

  List<Patient> parseResponsePatient2(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Patient>((json)=> Patient.fromJson(json)).toList();

  }


  Future<List<Patient>> getPatient3(String p_email, String pharm_email)async
  {

    var map = Map<String, dynamic>();

    map['p_email'] = p_email;
    map['pharm_email'] = pharm_email;


    try{

      String url = "https://doctor-on-call247.com/pizza/getPatient2.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Patient> list = parseResponsePatient(response.body);
        return list;
      }
      else{
        return  List<Patient>();
      }

    }
    catch(err){
      return List<Patient>();
    }
  }

  List<Patient> parseResponsePatient3(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Patient>((json)=> Patient.fromJson(json)).toList();

  }

  Future<List<Patient>> getPatient4(String email, String column)async
  {

    var map = Map<String, dynamic>();

    map['email'] = email;
    map['column'] = column;


    try{

      String url = "https://doctor-on-call247.com/pizza/getPat.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Patient> list = parseResponsePatient(response.body);

        return list;
      }
      else{
        return  List<Patient>();
      }

    }
    catch(err){
      return List<Patient>();
    }
  }

  List<Patient> parseResponsePatient4(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Patient>((json)=> Patient.fromJson(json)).toList();

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

  signUp(String email, String password, String table)async
  {
    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['password'] = password;
      map['table'] = table;
      String url = "https://doctor-on-call247.com/pizza/signup.php";
      http.Response res = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(res.statusCode == 200)
      {
        List result = json.decode(res.body);
        print(result);
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

  addClient(String name, String email, String phone, String age, String referer, String sex)async
  {
    try{
      var map = Map<String, dynamic>();
      map['name'] = name;
      map['email'] = email;
      map['phone'] = phone;
      map['age'] = age;
      map['referer'] = referer;
      map['sex'] = sex;
      String url = "https://doctor-on-call247.com/pizza/addClient.php";
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



  request(String email, String destination, String reason, String route, String hours, String type, String person)async
  {
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



  prescription(String p_name, String p_email, String p_phone, String p_age, String prescription, String doc_name,
      String doc_email, File file) async
  {


    String fileName = file.path.split('/').last;


    try{
      FormData formData = new FormData.fromMap({
        "p_name":p_name,
        "p_email": p_email,
        "p_phone":p_phone,
        "p_age":p_age,
        "prescription":prescription,
        "doc_name":doc_name,
        "doc_email":doc_email,
        "file": await MultipartFile.fromFile(file.path, filename: fileName)
      });

      Response response = await Dio().post("https://doctor-on-call247.com/pizza/prescription.php",
        data: formData,
      );


      if(response.statusCode == 200)
      {
        List result = json.decode(response.data);


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


  prescription2(String p_name, String p_email, String p_phone, String p_age, String prescription, String doc_name,
      String doc_email) async
  {


    var map = Map<String, dynamic>();
    map['p_name'] = p_name;
    map['p_email'] = p_email;
    map['p_phone'] = p_phone;
    map['p_age'] = p_age;
    map['prescription'] = prescription;
    map['doc_name'] = doc_name;
    map['doc_email'] = doc_email;

    try{

      String url = "https://doctor-on-call247.com/pizza/prescription.php";

      http.Response res = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(res.statusCode == 200)
      {
        List result = json.decode(res.body);
        print(result);
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





  updateProfile(String name, String email, String phone, String license, String type, String company, String address)async
  {

    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['phone'] = phone;
      map['names'] = name;
      map['license'] = license;
      map['type'] = type;
      map['company'] = company;
      map['address'] = address;
      String url = "https://doctor-on-call247.com/pizza/update.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);
        print(result);
        return result;
      }
      else{

        var error = json.decode(response.body);

        return error;
      }


    }
    catch(err)
    {
      return err.toString();
    }

  }

  updatePrescription(String name, String email,String code)async
  {

    try{
      var map = Map<String, dynamic>();
      map['name'] = name;
      map['email'] = email;
      map['code'] = code;
      String url = "https://doctor-on-call247.com/pizza/updatePres.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);
        print(result);
        return result;
      }
      else{

        var error = json.decode(response.body);

        return error;
      }


    }
    catch(err)
    {
      return err.toString();
    }

  }

  updateClient(String name, String email, String phone, String sex, String age)async
  {

    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['phone'] = phone;
      map['name'] = name;
      map['sex'] = sex;
      map['age'] = age;
      String url = "https://doctor-on-call247.com/pizza/updateClient.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);
        print(result);
        return result;
      }
      else{

        var error = json.decode(response.body);

        return error;
      }


    }
    catch(err)
    {
      return err.toString();
    }

  }

  deleteClient(String email)async
  {

    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      String url = "https://doctor-on-call247.com/pizza/deleteClient.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);
        print(result);
        return result;
      }
      else{

        var error = json.decode(response.body);

        return error;
      }


    }
    catch(err)
    {
      return err.toString();
    }

  }

  updateAgent(String name, String email, String phone, String company, String address,
      String code, String type, File file) async
  {


    String fileName = file.path.split('/').last;


    try{
      FormData formData = new FormData.fromMap({
        "names":name,
        "company":company,
        "address":address,
        "phone":phone,
        "email":email,
        "code":code,
        "type": type,
        "file": await MultipartFile.fromFile(file.path, filename: fileName)
      });

      Response response = await Dio().post("https://doctor-on-call247.com/pizza/update.php",
        data: formData,
      );


      if(response.statusCode == 200)
      {
        List result = json.decode(response.data);

        print(result);
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


  updateAgent2(String name, String email, String phone, String license, String company, String address, String code,String type)async
  {

    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['phone'] = phone;
      map['names'] = name;
      map['license'] = license;
      map['type'] = type;
      map['company'] = company;
      map['address'] = address;
      map['code'] = code;
      String url = "https://doctor-on-call247.com/pizza/update.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);

        return result;
      }
      else{

        var error = json.decode(response.body);

        return error;
      }


    }
    catch(err)
    {
      return err.toString();
    }

  }

  updatePayment(String client, String price)async
  {

    try{
      var map = Map<String, dynamic>();
      map['client'] = client;
      map['price'] = price;

      String url = "https://doctor-on-call247.com/pizza/updateAgent.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);
        print(result);
        return result;
      }
      else{

        var error = json.decode(response.body);

        return error;
      }


    }
    catch(err)
    {
      return err.toString();
    }

  }


  checkStatus(String email, String table)async
  {
    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['table'] = table;

      String url = "https://doctor-on-call247.com/pizza/checkStatus.php";
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

  login(String email, String password, String type)async
  {
    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['password'] = password;
      map['type'] = type;

      String url = "https://doctor-on-call247.com/pizza/login.php";
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



  Future<List<User>> getData(String email, String type)async
  {

    var map = Map<String, dynamic>();

    map['email'] = email;
    map['type'] = type;


    try{

      String url = "https://doctor-on-call247.com/pizza/getData.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<User> list = parseResponseUser(response.body);

        return list;
      }
      else{
        return  List<User>();
      }

    }
    catch(err){
      return List<User>();
    }
  }

  List<User> parseResponseUser(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json)=>User.fromJson(json)).toList();

  }


  Future<List<Doctor>> getDoctor(String email, String type)async
  {

    var map = Map<String, dynamic>();

    map['email'] = email;
    map['type'] = type;


    try{

      String url = "https://doctor-on-call247.com/pizza/getData.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {


        List<Doctor> list = parseResponseDoctor(response.body);

        return list;
      }
      else{
        return  List<Doctor>();
      }

    }
    catch(err){
      return List<Doctor>();
    }
  }

  List<Doctor> parseResponseDoctor(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Doctor>((json)=>Doctor.fromJson(json)).toList();

  }

  pwdReset(String email, String table)async
  {
    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['table'] = table;

      String url = "https://doctor-on-call247.com/pizza/email.php";
      http.Response res = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(res.statusCode == 200)
      {
        List result = json.decode(res.body);
        print(result);
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














}
