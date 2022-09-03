import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:settings_ui/settings_ui.dart';

class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeModeView();
  }
}

class ThemeModeView extends StatefulWidget {
  const ThemeModeView({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Appearance'),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('跟随系统'),
            tiles: [
              SettingsTile.switchTile(
                onToggle: (value) {
                  final isDark = Theme.of(context).colorScheme.brightness ==
                      Brightness.dark;
                  final currentMode = isDark ? ThemeMode.dark : ThemeMode.light;
                  setState(() {
                    _auto = value;
                    _mode = currentMode;
                  });
                  if (value) {
                    BlocProvider.of<AppCubit>(context)
                        .setThemeMode(ThemeMode.system);
                  } else {
                    BlocProvider.of<AppCubit>(context)
                        .setThemeMode(currentMode);
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
              SettingsTile.navigation(
                title: const Text('普通模式'),
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
              SettingsTile.navigation(
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
      ),
    );
  }
}
