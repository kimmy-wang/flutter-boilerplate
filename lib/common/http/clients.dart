import 'package:flutter_boilerplate/common/constants/constants.dart';
import 'package:http_trending_api/http_trending_api.dart';

class TrendingHttpBaseClient extends AbstractBaseClient {
  TrendingHttpBaseClient(String baseUrl, {Client? inner})
      : _inner = inner ?? Client(), super(baseUrl);

  final Client _inner;

  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(Constants.headers);
    return _inner.send(request);
  }
}
