import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/app/app_bloc_observer.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:repository_middleware/repository_middleware.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:trending_api/trending_api.dart';
import 'package:trending_repository/trending_repository.dart';

void bootstrap({
  required TrendingApi trendingApi,
  required RepositoryMiddleware repositoryMiddleware,
}) {
  FlutterError.onError = (details) async {
    log(details.exceptionAsString(), stackTrace: details.stack);
    await Sentry.captureException(details.exception, stackTrace: details.stack);
  };

  final trendingRepository = TrendingRepository(
    trendingApi: trendingApi,
    repositoryMiddleware: repositoryMiddleware,
  );

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async {
          await SentryFlutter.init(
            (options) {
              options..dsn =
                  'https://8dfc3db2260545d28251d562b94ee4ef@o4503951550316544.ingest.sentry.io/4503951553527808'
              // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
              // We recommend adjusting this value in production.
              ..tracesSampleRate = 1.0;
            },
          );
          runApp(
            App(
              trendingRepository: trendingRepository,
            ),
          );
        },
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) async {
      log(error.toString(), stackTrace: stackTrace);
      await Sentry.captureException(error, stackTrace: stackTrace);
    },
  );
}
