import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:settings_ui/settings_ui.dart';

class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeModeView();
  }
}

class ThemeModeView extends StatefulWidget {
  const ThemeModeView({super.key});

  @override
  State<ThemeModeView> createState() => _ThemeModeViewState();
}

class _ThemeModeViewState extends State<ThemeModeView> {
  bool _auto = true;
  ThemeMode? _mode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _auto =
        BlocProvider.of<AppCubit>(context).state.themeMode == ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isMacOS
        ? _macosScaffold
        : Scaffold(
            appBar: AppBar(
              title: const Text('Dark Appearance'),
              centerTitle: true,
            ),
            body: _body,
          );
  }

  Widget get _macosScaffold {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Dark Appearance'),
        titleWidth: 150.0,
        leading: MacosTooltip(
          message: 'Back',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.back,
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
            onPressed: () => NavigatorUtil.pop(context),
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
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('跟随系统'),
          tiles: [
            SettingsTile.switchTile(
              onToggle: (value) {
                final isDark =
                    Theme.of(context).colorScheme.brightness == Brightness.dark;
                final currentMode = isDark ? ThemeMode.dark : ThemeMode.light;
                setState(() {
                  _auto = value;
                  _mode = currentMode;
                });
                if (value) {
                  BlocProvider.of<AppCubit>(context)
                      .setThemeMode(ThemeMode.system);
                } else {
                  BlocProvider.of<AppCubit>(context).setThemeMode(currentMode);
                }
              },
              initialValue: _auto,
              title: const Text('跟随系统'),
              description: const Text('开启后, 将跟随系统打开或关闭深色模式'),
            ),
          ],
        ),
        if (!_auto)
          SettingsSection(title: const Text('手动选择'), tiles: [
            SettingsTile(
              title: const Text('白天模式'),
              trailing: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: _mode,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    _mode = value;
                  });
                  if (value != null) {
                    BlocProvider.of<AppCubit>(context).setThemeMode(value);
                  }
                },
              ),
            ),
            SettingsTile(
              title: const Text('深色模式'),
              trailing: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: _mode,
                onChanged: (ThemeMode? value) {
                  setState(() {
                    _mode = value;
                  });
                  if (value != null) {
                    BlocProvider.of<AppCubit>(context).setThemeMode(value);
                  }
                },
              ),
            ),
          ]),
      ],
    );
  }
}
