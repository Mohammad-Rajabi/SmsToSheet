

import 'package:sms_to_sheet/src/data/model/sms_response_model.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';

abstract class ISmsDataSource{
  Future<List<SmsModel>> getSms();

  Future<SmsResponseModel> edit({required SmsModel sms});


  Future<SmsResponseModel> sendSms({required String ssid,required SmsModel sms,required String isEditMode});

}