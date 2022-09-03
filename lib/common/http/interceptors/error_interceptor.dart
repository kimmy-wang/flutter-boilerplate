
import 'package:dio_trending_api/dio_trending_api.dart';

class ErrorInterceptor extends InterceptorsWrapper {

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if(err.response!.statusCode == 401) {

      return;
    }
    handler.reject(err);
  }
}
