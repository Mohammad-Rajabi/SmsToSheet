import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:sms_to_sheet/src/core/util/dio_interceptor.dart';
import 'package:yaml/yaml.dart';

class HttpClientService {
  static HttpClientService? _instance;
  Dio? _dio;
  BuildContext _context;

  Future<Dio> get dio async {
    if (_dio == null) {
      await getConfigs().then((value) {
        _dio = Dio(
          BaseOptions(
            baseUrl: value['base_url'],
            connectTimeout: 10000,
            sendTimeout: 10000,
            receiveTimeout: 10000,
          ),
        )..interceptors.add(
            DioInterceptor(),
          );
      });
    }
    return _dio!;
  }

  HttpClientService._(
      {required BuildContext context})
      : _context = context;

  factory HttpClientService({required BuildContext context}) {
    _instance ??=
        HttpClientService._(context: context);
    return _instance!;
  }

  Future<dynamic> getConfigs() async {
    final yamlString =
    await DefaultAssetBundle.of(_context).loadString('assets/config.yaml');
    final parsedYaml = loadYaml(yamlString);
    return parsedYaml;
  }

}

