import 'package:sms_to_sheet/src/data/data_source/sms_data_source.dart';
import 'package:sms_to_sheet/src/data/model/sms_response_model.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';

class SmsRepo implements ISmsDataSource {
  ISmsDataSource _smsDataSource;

  SmsRepo({required ISmsDataSource smsDataSource})
      : _smsDataSource = smsDataSource;

  @override
  Future<List<SmsModel>> getSms() => _smsDataSource.getSms();

  @override
  Future<SmsResponseModel> edit({required SmsModel sms}) =>
      _smsDataSource.edit(sms: sms);

  @override
  Future<SmsResponseModel> sendSms(
          {required String ssid,
          required SmsModel sms,
          required String isEditMode}) =>
      _smsDataSource.sendSms(ssid: ssid, sms: sms, isEditMode: isEditMode);
}
