part of 'bottom_sheet_bloc.dart';

abstract class BottomSheetEvent extends Equatable{

  @override
  List<Object> get props =>[];
}

class BottomSheetEdited extends BottomSheetEvent {
  SmsModel sms;
  BuildContext context;
  String value;

  BottomSheetEdited({required this.sms,required this.context,required this.value});

  @override
  List<Object> get props =>[sms,value];
}
