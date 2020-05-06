import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mydstv_gotv_self_service/models/bouquet.dart';
import 'package:mydstv_gotv_self_service/models/channel.dart';
import 'package:mydstv_gotv_self_service/models/error_code.dart';
import 'package:mydstv_gotv_self_service/models/mobilecustomer.dart';
import 'package:mydstv_gotv_self_service/models/package.dart';
import 'package:mydstv_gotv_self_service/models/products.dart';
import 'package:mydstv_gotv_self_service/models/transaction.dart';
import 'package:mydstv_gotv_self_service/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mydstv_gotv_self_service/utilities/constant.dart';


class DatabaseService
{
  static const ROOT = "http://192.168.0.178/EMPLOYEE/employee_actions.php";
  static const _CREATE_TABLE_ACTION = "CREATE_TABLE";


  static const _DELETE_EMP = "DELETE_EMP";


  static DatabaseService user;

  static Future<String> createTable()async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;

      final response = await http.post(ROOT, body: map);

      if(response.statusCode == 200){
        return response.body;
      }
      else{
        return "error";
      }

    }
    catch(err){
      return "error";
    }
  }

  Future<List<Products>> getItems(String table)async
  {

    var map = Map<String, dynamic>();
    map['table'] = table;


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getProducts.php";
      var response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});


      if(response.statusCode == 200)
      {
        List<Products> list = parseResponse(response.body);
        return list;
      }
      else{
        return  List<Products>();
      }

    }
    catch(err){
      return List<Products>();
    }
  }

  List<Products> parseResponse(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Products>((json)=> Products.fromJson(json)).toList();

  }

  Future<List<Transactions>> getTransaction(String email)async
  {

    var map = Map<String, dynamic>();
    map['table'] = "transaction";
    map['email'] = email;


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getTransaction.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<Transactions> list = parseResponseTransact(response.body);

        return list;
      }
      else{
        return  List<Transactions>();
      }

    }
    catch(err){
      return List<Transactions>();
    }
  }

  List<Transactions> parseResponseTransact(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Transactions>((json)=> Transactions.fromJson(json)).toList();

  }

  Future<List<Channels>> getChannel()async
  {


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getChannel.php";
      http.Response response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<Channels> list = parseResponseChannel(response.body);
        return list;

      }
      else{
        return  List<Channels>();
      }

    }
    catch(err){
      return List<Channels>();
    }
  }

  List<Channels> parseResponseChannel(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Channels>((json)=>Channels.fromJson(json)).toList();

  }

  Future<List<Channels>> getChannel2(String package)async
  {

    var map = Map<String, dynamic>();
    map['package'] = package;


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getChannel3.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<Channels> list = parseResponseChannel(response.body);

        return list;

      }
      else{
        return  List<Channels>();
      }

    }
    catch(err){
      return List<Channels>();
    }
  }

  List<Channels> parseResponseChannel2(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Channels>((json)=>Channels.fromJson(json)).toList();

  }

  Future<List<Package>> getPackage()async
  {


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getPackage.php";
      http.Response response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<Package> list = parseResponsePackage(response.body);

        return list;
      }
      else{
        return  List<Package>();
      }

    }
    catch(err){
      return List<Package>();
    }
  }

  List<Package> parseResponsePackage(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Package>((json)=>Package.fromJson(json)).toList();

  }

  Future<List<Bouquet>> getBouquet()async
  {

    var map = Map<String, dynamic>();
    map['table'] = "bouquet_fresh";


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getItem.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<Bouquet> list = parseResponseBouquet(response.body);
        return list;
      }
      else{
        return  List<Bouquet>();
      }

    }
    catch(err){
      return List<Bouquet>();
    }
  }

  Future<Bouquet> getSingleBouquet(String table, String bouquet)async
  {

    var map = Map<String, dynamic>();
    map['table'] = table;
    map['bouquet'] = bouquet;


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getSingleItem.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});


      if(response.statusCode == 200)
      {

        Bouquet list = parseResponseSingleBouquet(response.body);
        return list;
      }
      else{
        return  Bouquet();
      }

    }
    catch(err){
      return Bouquet();
    }
  }
  List<Bouquet> parseResponseBouquet(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Bouquet>((json)=> Bouquet.fromJson(json)).toList();

  }

  Future<List<Bouquet>> getBouquetPerBrand(String brand)async
  {

    var map = Map<String, dynamic>();
    map['table'] = "bouquet_fresh";
    map['brand'] = brand;


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getItemPerBrand.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        print('from server: '+response.body);
        List<Bouquet> list = parseResponseBouquetPerBrand(response.body);
        return list;
      }
      else{
        return  List<Bouquet>();
      }

    }
    catch(err){
      return List<Bouquet>();
    }
  }

  List<Bouquet> parseResponseBouquetPerBrand(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Bouquet>((json)=> Bouquet.fromJson(json)).toList();

  }


  Future<List<ErrorCode>> getError()async
  {

    var map = Map<String, dynamic>();
    map['table'] = "error_codes";


    try{

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/getItem.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {

        List<ErrorCode> list = parseResponseErrorCode(response.body);
        return list;
      }
      else{
        return  List<ErrorCode>();
      }

    }
    catch(err){
      return List<ErrorCode>();
    }
  }

  List<ErrorCode> parseResponseErrorCode(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ErrorCode>((json)=> ErrorCode.fromJson(json)).toList();

  }


  Bouquet parseResponseSingleBouquet(String responseBody)
  {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Bouquet>((json)=> Bouquet.fromJson(json)).toList();

  }

  static Future<User> getSingleUser(String email)async
  {

    try{
      var map = Map<String, dynamic>();
      map['email'] = email;

      final response = await http.post(ROOT, body: map);
      if(response.statusCode == 200){
        User user = parseResponseSingle(response.body);
        return user;
      }
      else
        {
        return  User();
      }

    }
    catch(err){
      return User();
    }
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
    return parsed.map<User>((json)=> MobileCustomer.fromJson(json)).toList();

  }

    addUser(String name, String email,String phone, String password)async{
    try{
      var map = Map<String, dynamic>();
      map['names'] = name;
      map['email'] = email;
      map['password'] = password;
      map['phone'] = phone;
      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/signup.php";
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

  updateUser(String email, String phone)async
  {

    try{
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['phone'] = phone;
      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/update.php";
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

  addSubscription(String brand, String bouquet, String month, String total, String iuc, String email, String reference)async
  {
    try{
      var map = Map<String, dynamic>();
      map['brand'] = brand;
      map['bouquet'] = bouquet;
      map['month'] = month;
      map['total'] = total;
      map['iuc'] = iuc;
      map['email'] = email;
      map['reference'] = reference;

      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/sub.php";
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

  addPurchase(String brand, String product, String email, String quantity, String price, String reference)async
  {
    try{
      var map = Map<String, dynamic>();
      map['brand'] = brand;
      map['product'] = product;
      map['email'] = email;
      map['quantity'] = quantity;
      map['price'] = price;
      map['reference'] = reference;


      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/purchase.php";
      http.Response response  = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
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

  addError(String iuc, String code, String email)async
  {
    try{
      var map = Map<String, dynamic>();
      map['iuc'] = iuc;
      map['code'] = code;
      map['email'] = email;


      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/errorCode.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});

      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);

        return result;
      }
      else{

        var error = json.decode(response.body);
        print(error);
        return error;
      }

    }
    catch(err)
    {
      print(err);
      return err.toString();
    }
  }

  requestInstallation(String brand, String service, String address, String email)async
  {
    try{
      var map = Map<String, dynamic>();
      map['brand'] = brand;
      map['service'] = service;
      map['address'] = address;
      map['email'] = email;


      String url = "https://mydstvgotvforselfservice.com/new_mobile/pizza/requestInstallation.php";
      http.Response response = await http.post(Uri.encodeFull(url), body: map, headers: {"Accept": "application/json"});
      if(response.statusCode == 200)
      {
        List result = json.decode(response.body);
        return result;
      }
      else{

        var error = json.decode(response.body);
        print(error);
        return error;
      }


    }
    catch(err)
    {
      print(err);
      return err.toString();
    }
  }




  static Future<String> deleteUser(int id)async
  {

    try{
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP;
      map['id'] = id;
      final response = await http.post(ROOT, body: map);

      if(response.statusCode == 200){
        return response.body;
      }
      else{
        return "error";
      }

    }
    catch(err){
      return "error";
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
      'phone' : user.phone,
    });
  }












}
