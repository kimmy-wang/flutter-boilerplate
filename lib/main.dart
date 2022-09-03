import 'package:dio_trending_api/dio_trending_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/bootstrap.dart';
import 'package:flutter_boilerplate/common/http/other_http.dart';
import 'package:local_storage_trending_repository_middleware/local_storage_trending_repository_middleware.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final trendingApi = DioTrendingApi(dio: trendingHttp);
  final trendingRepositoryMiddleware = LocalStorageTrendingRepositoryMiddleware(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(
    trendingApi: trendingApi,
    trendingRepositoryMiddleware: trendingRepositoryMiddleware,
  );
}
