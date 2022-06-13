

import 'package:sms_to_sheet/src/data/model/sms_edit_response.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';

abstract class ISmsDataSource{
  Future<List<SmsModel>> getSms();

  Future<SmsEditResponse> edit({required SmsModel sms});
}