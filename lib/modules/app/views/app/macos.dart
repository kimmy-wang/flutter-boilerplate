
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/constants/constants.dart';
import 'package:flutter_boilerplate/common/dio/widget/http_error_boundary.dart';
import 'package:flutter_boilerplate/common/utils/sp_util.dart';
import 'package:flutter_boilerplate/common/utils/string_util.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/intro/intro.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MacosAppView extends StatelessWidget {
  MacosAppView({super.key});

  final httpErrorBoundary = HttpErrorBoundary.init();
  final easyLoading = EasyLoading.init();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, AppState state) => MacosApp(
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],
        home: _home,
        builder: (BuildContext context, Widget? child) {
          final newChild = httpErrorBoundary(context, child);
          final newChild2 = easyLoading(context, newChild);
          return newChild2;
        },
      ),
    );
  }

  Widget get _home {
    return StringUtil.isBlank(SpUtil.getString(Constants.introKey))
        ? const IntroPage()
        : const HomePage();
  }
}
