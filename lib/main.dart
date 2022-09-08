import 'dart:io';

import 'package:dio_trending_api/dio_trending_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/bootstrap.dart';
import 'package:flutter_boilerplate/common/dio/other_http.dart';
import 'package:flutter_boilerplate/common/http/clients.dart';
import 'package:http_trending_api/http_trending_api.dart';
import 'package:local_storage_trending_repository_middleware/local_storage_trending_repository_middleware.dart';
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

  final trendingApi = HttpTrendingApi(client: client);
  final trendingRepositoryMiddleware = LocalStorageTrendingRepositoryMiddleware(
    plugin: await SharedPreferences.getInstance(),
  );

  if (isDesktop) {
    await WindowManager.instance.ensureInitialized();
    await windowManager.waitUntilReadyToShow().then((_) async {
      if (!Platform.isMacOS) {
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
