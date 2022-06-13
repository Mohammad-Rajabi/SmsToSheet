import 'dart:async';

import 'package:sms_to_sheet/src/data/model/sms_model.dart';

class SmsListUpdateRepo{

  final StreamController<SmsModel> _updateController = StreamController();
  StreamSink<SmsModel> get updateSink => _updateController.sink;

  Stream<SmsModel> get updateStream => _updateController.stream;
}