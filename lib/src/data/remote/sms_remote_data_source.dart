import 'package:dio/dio.dart';
import 'package:sms_to_sheet/src/core/constants/general_constants.dart';
import 'package:sms_to_sheet/src/core/util/http_client_service.dart';
import 'package:sms_to_sheet/src/data/data_source/sms_data_source.dart';
import 'package:sms_to_sheet/src/data/model/sms_response_model.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';


class SmsRemoteDataSource extends ISmsDataSource {
  HttpClientService _httpClientService;

  SmsRemoteDataSource({required HttpClientService httpClientService})
      : _httpClientService = httpClientService;


  @override
  Future<List<SmsModel>> getSms() async {
    final dio = await _httpClientService.dio;
    final response = await dio.get(kEndPoint);


    List<SmsModel> smsList = [];
    for(var json in (response.data as List)){
      smsList.add(SmsModel.fromJson(json));
    }
    return smsList;
  }

  @override
  Future<SmsResponseModel> edit({required SmsModel sms}) async {
    final dio = await _httpClientService.dio;

    FormData formData = new FormData.fromMap({
      "ssid": kSpreadSheetId,
      "description": sms.description,
      "jalaliDate": sms.jalaliDate,
      "isEditMode":"true"
    });

    final response = await dio.post(kEndPoint,data: formData);


    SmsResponseModel smsEditResponse = SmsResponseModel.fromJson(response.data);
    return smsEditResponse;
  }

  @override
  Future<SmsResponseModel> sendSms({required String ssid, required SmsModel sms, required String isEditMode}) async {
    final dio = await _httpClientService.dio;

    FormData formData = new FormData.fromMap({
      "ssid": kSpreadSheetId,
      "description": sms.description,
      "jalaliDate": sms.jalaliDate,
      "gregorianDate":sms.gregorianDate,
      "isEditMode":"true"
    });

    final response = await dio.post(kEndPoint,data: formData);


    SmsResponseModel smsEditResponse = SmsResponseModel.fromJson(response.data);
    return smsEditResponse;
  }




}
