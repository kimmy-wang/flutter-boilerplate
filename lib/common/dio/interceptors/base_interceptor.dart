import 'package:dio_trending_api/dio_trending_api.dart';
import 'package:flutter_boilerplate/common/constants/constants.dart';
import 'package:flutter_boilerplate/common/dio/code.dart';

class BaseInterceptor extends InterceptorsWrapper {

  BaseInterceptor(this.baseUrl);
  final String baseUrl;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: Constants.timeOut) //5s
      ..receiveTimeout = const Duration(seconds: Constants.timeOut)
      ..headers.addAll(Constants.headers);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != 200) {
      return handler.reject(
        DioError(
          requestOptions: response.requestOptions,
          error: Code.errorHandleFunction(
            response.statusCode,
            response.statusMessage,
          ),
        ),
      );
    }
    super.onResponse(response, handler);
  }
}
