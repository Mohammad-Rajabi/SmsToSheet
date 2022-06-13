import 'package:sms_to_sheet/src/data/data_source/sms_data_source.dart';
import 'package:sms_to_sheet/src/data/model/sms_edit_response.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';

class SmsRepo implements ISmsDataSource{

  ISmsDataSource _smsDataSource;
  SmsRepo({required ISmsDataSource smsDataSource}):_smsDataSource=smsDataSource;

  @override
  Future<List<SmsModel>> getSms() => _smsDataSource.getSms();

  @override
  Future<SmsEditResponse> edit({required SmsModel sms}) => _smsDataSource.edit(sms:sms);


}