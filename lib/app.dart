import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sms_to_sheet/src/core/constants/general_constants.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_list_update_repo.dart';

import 'src/bloc/main_bloc/main_bloc.dart';
import 'src/core/util/http_client_service.dart';
import 'src/data/remote/sms_remote_data_source.dart';
import 'src/data/repositories/sms_repo.dart';
import 'src/view/main_screen/main_screen.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => HttpClientService(context: context),
            lazy: true,
          ),
          RepositoryProvider(
            create: (context) => SmsRemoteDataSource(
                httpClientService:
                    RepositoryProvider.of<HttpClientService>(context)),
            lazy: true,
          ),
          RepositoryProvider(
            create: (context) => SmsRepo(
                smsDataSource:
                    RepositoryProvider.of<SmsRemoteDataSource>(context)),
            lazy: true,
          ),
          RepositoryProvider(
            create: (context) => SmsListUpdateRepo(),
            lazy: true,
          ),
          RepositoryProvider(
            create: (context) => MainBloc(
                smsRepo: RepositoryProvider.of<SmsRepo>(context),
                smsListUpdateRepo:
                    RepositoryProvider.of<SmsListUpdateRepo>(context)),
            lazy: true,
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: kNavigatorKey,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fa'),
            home: MainView()));
  }
}
