import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:settings_ui/settings_ui.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LanguagesView();
  }
}

class LanguagesView extends StatefulWidget {
  const LanguagesView({super.key});

  @override
  State<LanguagesView> createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  String? _languageCode;

  @override
  void initState() {
    super.initState();
    _languageCode =
        BlocProvider.of<AppCubit>(context).state.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isMacOS
        ? _macosScaffold
        : Scaffold(
            appBar: AppBar(
              title: const Text('LANGUAGES'),
              centerTitle: true,
            ),
            body: _body,
          );
  }

  Widget get _macosScaffold {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('LANGUAGES'),
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
        SettingsSection(tiles: [
          SettingsTile(
            title: const Text('英文'),
            trailing: Radio<String>(
              value: 'en',
              groupValue: _languageCode,
              onChanged: (String? value) {
                setState(() {
                  _languageCode = value;
                });
                if (value != null) {
                  BlocProvider.of<AppCubit>(context).setLocale(Locale(value));
                }
              },
            ),
          ),
          SettingsTile(
            title: const Text('中文'),
            trailing: Radio<String>(
              value: 'zh',
              groupValue: _languageCode,
              onChanged: (String? value) {
                setState(() {
                  _languageCode = value;
                });
                if (value != null) {
                  BlocProvider.of<AppCubit>(context).setLocale(Locale(value));
                }
              },
            ),
          ),
        ]),
      ],
    );
  }
}
