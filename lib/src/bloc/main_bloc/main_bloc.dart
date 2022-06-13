import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_to_sheet/src/bloc/main_bloc/main_event.dart';
import 'package:sms_to_sheet/src/bloc/main_bloc/main_state.dart';
import 'package:sms_to_sheet/src/core/util/NoInternetException.dart';
import 'package:sms_to_sheet/src/core/util/enums.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_list_update_repo.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_repo.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  SmsRepo _smsRepo;
  late List<SmsModel> smsList;
  late SmsListUpdateRepo _smsListUpdateRepo;

  MainBloc(
      {required SmsRepo smsRepo,
      required SmsListUpdateRepo smsListUpdateRepo})
      : _smsRepo = smsRepo,
        _smsListUpdateRepo = smsListUpdateRepo,
        super(MainState(mainStateStatus: MainStateStatus.loading)) {
    on<MainStarted>(_onStarted);
    on<MainRetry>(_onRetry);
    on<MainUpdated>(_onUpdated);
    on<MainPullToRefresh>(_onRefreshed);

    _smsListUpdateRepo.updateStream.listen((sms) async {
      await Future.delayed(const Duration(microseconds: 500));
      add(MainUpdated(sms: sms));
    });
  }

  _onStarted(MainEvent event, Emitter<MainState> emit) async {

      try {
        smsList = await _smsRepo.getSms();
        emit(MainState(
            mainStateStatus: MainStateStatus.success, smsList: smsList));
      } on DioError catch (dioError) {
        if (_checkDioErrorType(dioError)) {
          emit(MainState(mainStateStatus: MainStateStatus.noInternet));
        } else {
          emit(MainState(mainStateStatus: MainStateStatus.failure));
        }
      } catch (error) {
        emit(MainState(mainStateStatus: MainStateStatus.failure));
      }

  }


  bool _checkDioErrorType(DioError dioError) {
    return dioError.type == DioErrorType.other &&
        dioError.error is NoInternetException;
  }

  _onRetry(MainRetry event, Emitter<MainState> emit) {
    emit(MainState(mainStateStatus: MainStateStatus.loading));
    Future.delayed(const Duration(seconds: 2))
        .then((value) => add(MainStarted()));
  }

  _onUpdated(MainUpdated event, Emitter<MainState> emit) {
    smsList.remove(event.sms);
    emit(MainState(mainStateStatus: MainStateStatus.update, smsList: smsList));
  }

  _onRefreshed(MainPullToRefresh event, Emitter<MainState> emit) {
    emit(MainState(mainStateStatus: MainStateStatus.loading));
    add(MainStarted());
  }

  @override
  Future<void> close() async {
    // _smsController.close();
    await super.close();
  }
}
