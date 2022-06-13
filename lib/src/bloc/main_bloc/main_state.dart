import 'package:equatable/equatable.dart';
import 'package:sms_to_sheet/src/core/util/enums.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';

class MainState extends Equatable {
  MainStateStatus mainStateStatus;
  List<SmsModel> smsList;

  MainState({required this.mainStateStatus,this.smsList = const []});

  @override
  List<Object> get props => [mainStateStatus,smsList];
}
