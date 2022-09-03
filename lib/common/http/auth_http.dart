import 'package:flutter_boilerplate/common/http/base_http.dart';
import 'package:flutter_boilerplate/common/http/interceptors/auth_interceptor.dart';

final AuthHttp authHttp = AuthHttp();

class AuthHttp extends BaseHttp {
  @override
  void init() {
    interceptors.addAll([AuthorizationInterceptor()]);
  }
}
