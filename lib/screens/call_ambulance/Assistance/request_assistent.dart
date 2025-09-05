
import 'dart:convert';

import 'package:http/http.dart' as http;
class RequestAssistent{

  static Future<dynamic> receiveRequest(String url) async{
    http.Response httpResposnse = await http.get(Uri.parse(url));

    try{
      if(httpResposnse.statusCode == 200)
      {
        String responseData = httpResposnse.body;
        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      }
      else{
        return 'Error Occured. Faild. No Response';
      }
    }
    catch(exp){
      return 'Error Occured. Faild. No Response';
    }
  }
}