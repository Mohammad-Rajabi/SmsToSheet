part of 'bottom_sheet_bloc.dart';

class BottomSheetState extends Equatable {
  BottomSheetStateStatus status;
  SmsModel? sms;

  BottomSheetState({required this.status, this.sms});

  @override
  List<Object> get props => [status];
}
