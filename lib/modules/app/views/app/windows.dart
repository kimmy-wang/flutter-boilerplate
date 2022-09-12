
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/dio/widget/http_error_boundary.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WindowsAppView extends StatelessWidget {
  WindowsAppView({super.key});

  final httpErrorBoundary = HttpErrorBoundary.init();
  final easyLoading = EasyLoading.init();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (BuildContext context, AppState state) => FluentApp(
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
        builder: (BuildContext context, Widget? child) {
          final newChild = httpErrorBoundary(context, child);
          final newChild2 = easyLoading(context, newChild);
          return newChild2;
        },
      ),
    );
  }
}
