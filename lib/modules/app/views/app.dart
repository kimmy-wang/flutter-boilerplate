import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/http/widget/http_error_boundary.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';
import 'package:flutter_boilerplate/modules/app/cubit/app_cubit.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/theme/theme.dart';
import 'package:trending_repository/trending_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.trendingRepository,
  });

  final TrendingRepository trendingRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: trendingRepository,
      child: BlocProvider(
        create: (_) => AppCubit(),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  AppView({super.key});
  final httpErrorBoundary = HttpErrorBoundary.init();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, AppState state) => MaterialApp(
        theme: FlutterBoilerplateTheme.light,
        darkTheme: FlutterBoilerplateTheme.dark,
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        builder: (BuildContext context, Widget? child) {
          final newChild = httpErrorBoundary(context, child);
          return newChild;
        },
      ),
    );
  }
}
