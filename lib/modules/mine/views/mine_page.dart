import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_boilerplate/l10n/l10n.dart';
import 'package:flutter_boilerplate/modules/app/cubit/app_cubit.dart';
import 'package:flutter_boilerplate/modules/mine/mine.dart';
import 'package:macos_ui/macos_ui.dart';
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
    if (kIsWeb) return _materialScaffold;
    if (Platform.isIOS) return _iosScaffold;
    if (Platform.isMacOS) return _macosScaffold(context);
    return _materialScaffold;
  }

  Widget get _materialScaffold {
    return Scaffold(
      body: _body,
    );
  }

  Widget get _iosScaffold {
    return _body;
  }

  Widget _macosScaffold(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Mine'),
        titleWidth: 150.0,
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return _body;
        })
      ],
    );
  }

  Widget get _body {
    return BlocBuilder<AppCubit, AppState>(
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
    );
  }
}
