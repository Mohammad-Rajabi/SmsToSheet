import 'package:dio/dio.dart';

validateResponse(Response response){
  if(response.statusCode != 200){
    throw Exception();
  }
}