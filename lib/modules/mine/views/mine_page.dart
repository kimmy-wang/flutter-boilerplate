import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';
import 'package:flutter_boilerplate/modules/app/cubit/app_cubit.dart';
import 'package:flutter_boilerplate/modules/mine/mine.dart';
import 'package:settings_ui/settings_ui.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MineView();
  }
}

class MineView extends StatelessWidget {
  const MineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppState>(
        builder: (BuildContext context, AppState state) => SettingsList(
          sections: [
            SettingsSection(
              title: const Text('APPEARANCE'),
              tiles: [
                SettingsTile.navigation(
                  onPressed: (_) {
                    NavigatorUtil.push(context, const ThemeModePage());
                  },
                  title: const Text('Dark Appearance'),
                  value: Text(
                    state.themeMode == ThemeMode.system
                        ? '跟随系统'
                        : state.themeMode == ThemeMode.dark
                            ? '黑暗模式'
                            : '白天模式',
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('LANGUAGES'),
              tiles: [
                SettingsTile.navigation(
                  onPressed: (_) {
                    NavigatorUtil.push(context, const LanguagesPage());
                  },
                  title: const Text('Language'),
                  value: Text(
                    state.locale.languageCode == 'zh'
                        ? context.l10n.languagesZh
                        : context.l10n.languagesEn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
