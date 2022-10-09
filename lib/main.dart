import 'dart:io';

import 'package:dio_trending_api/dio_trending_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/bootstrap.dart';
import 'package:flutter_boilerplate/common/constants/constants.dart';
import 'package:flutter_boilerplate/common/dio/other_http.dart';
import 'package:flutter_boilerplate/common/http/clients.dart';
import 'package:flutter_boilerplate/common/utils/sp_util.dart';
import 'package:http_trending_api/http_trending_api.dart';
import 'package:local_storage_trending_repository_middleware/local_storage_trending_repository_middleware.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  final trendingApi = HttpTrendingApi(
    client: TrendingHttpBaseClient(
      Constants.githubTrendingApiPrefix,
      client: SentryHttpClient(),
    ),
  );
  final trendingRepositoryMiddleware = LocalStorageTrendingRepositoryMiddleware(
    plugin: await SharedPreferences.getInstance(),
  );

  if (isDesktop) {
    await WindowManager.instance.ensureInitialized();
    await windowManager.waitUntilReadyToShow().then((_) async {
      if (Platform.isWindows) {
        await windowManager.setTitleBarStyle(
          TitleBarStyle.hidden,
          windowButtonVisibility: false,
        );
      }

      // await windowManager.setSize(const Size(755, 545));
      // await windowManager.setMinimumSize(const Size(755, 545));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  bootstrap(
    trendingApi: trendingApi,
    trendingRepositoryMiddleware: trendingRepositoryMiddleware,
  );
}
