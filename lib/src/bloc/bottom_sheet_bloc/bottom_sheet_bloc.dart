import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_to_sheet/src/core/util/NoInternetException.dart';
import 'package:sms_to_sheet/src/core/util/enums.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_list_update_repo.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_repo.dart';

part 'bottom_sheet_event.dart';

part 'bottom_sheet_state.dart';

class BottomSheetBloc extends Bloc<BottomSheetEvent, BottomSheetState> {
  SmsRepo _smsRepo;

  final TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  late SmsListUpdateRepo _smsListUpdateRepo;

  BottomSheetBloc(
      {required SmsRepo smsRepo, required SmsListUpdateRepo smsListUpdateRepo})
      : _smsRepo = smsRepo,
        _smsListUpdateRepo = smsListUpdateRepo,
        super(BottomSheetState(status: BottomSheetStateStatus.initial)) {
    on<BottomSheetEdited>(_onEdited);
  }

  _onEdited(BottomSheetEdited event, Emitter<BottomSheetState> emit) async {
    if (controller.hasListeners && controller.text.isNotEmpty) {
      try {
        SmsModel sms = event.sms;
        sms.description = event.value;
        emit(BottomSheetState(status: BottomSheetStateStatus.sending));

        await _smsRepo.edit(sms: sms);
      } on DioError catch (dioError) {
        if (dioError.response != null && dioError.response!.statusCode == 302) {
          emit(BottomSheetState(
              status: BottomSheetStateStatus.success, sms: event.sms));
          controller.clear();
          _smsListUpdateRepo.updateSink.add(event.sms);
          Navigator.pop(event.context);
        } else if (dioError.type == DioErrorType.other &&
            dioError.error is NoInternetException) {
          emit(BottomSheetState(
              status: BottomSheetStateStatus.noInternet));
        } else {
          emit(BottomSheetState(
            status: BottomSheetStateStatus.failure,
          ));
        }
      } catch (error) {
        emit(BottomSheetState(
          status: BottomSheetStateStatus.failure,
        ));
      }
    }
  }
}
