import 'package:equatable/equatable.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MainStarted extends MainEvent {}

class MainRetry extends MainEvent {}

class MainPullToRefresh extends MainEvent {}

class MainUpdated extends MainEvent {
  SmsModel sms;

  MainUpdated({required this.sms});
  @override
  List<Object> get props => [sms];
}
