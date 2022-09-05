import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/app/app_bloc_observer.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:trending_api/trending_api.dart';
import 'package:trending_repository/trending_repository.dart';
import 'package:trending_repository_middleware/trending_repository_middleware.dart';

void bootstrap({
  required TrendingApi trendingApi,
  required TrendingRepositoryMiddleware trendingRepositoryMiddleware,
}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final trendingRepository = TrendingRepository(
    trendingApi: trendingApi,
    trendingRepositoryMiddleware: trendingRepositoryMiddleware,
  );

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(
            trendingRepository: trendingRepository,
          ),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
