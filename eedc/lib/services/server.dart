
import 'dart:convert' show utf8, base64, json;
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:eedc/data/shared_pref.dart';
import 'package:eedc/model/user_data.dart';
import 'package:http/http.dart' as http;

class Server
{
  static Future<bool> addBIll(String account, String previous, String current, String month, String year, dynamic image )async
  {


    var data =  json.encode({
      'customer_acc_no': account,
      'previous_read': previous,
      'current_read': current,
      'e_month': month,
      'e_year': year,
      'image': image

    });
    var data2 = json.encode({
      '"params"': data
    });
    var formData = FormData.fromMap({
      'data': json.decode(data2)
    });


      String url = "http://87.106.171.232:8069/web/json/feeder.customer.details";

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Basic ${UserData.token}";

      try{
        Response response = await dio.post(url, data: formData);

        if(response.data['result'] != 'error')
        {
          return true;
        }else{
          return false;
        }




      }
      catch(e){
        print('error: $e');
        return false;
      }




  }

  static Future<bool> login(var token)async
  {


    final tokens = base64.encode(utf8.encode(token));


    String url = "http://87.106.171.232:8069/customer/login/res.users";

    Dio dio = new Dio();
    dio.options.headers['Content-Type'] = 'application/ecmascript';
    dio.options.headers["Authorization"] = "Basic $tokens";
    dio.options.headers["set-cookie"] = "frontend_lang=en_US";
    dio.options.headers["session_id"] = "2fb2babe928e367612267f6994b28655047e9a21";



    try{
      Response response = await dio.get(Uri.encodeFull(url));
      print('response: $response');

      if(response.data['user_id'] != null)
      {
        UserData.token = tokens;
        SharedPref.setFcmRegId(tokens);
        return true;
      }else{
        return false;
      }

    }
    catch(e){
      print('error: $e');
      return false;
    }







  }
}