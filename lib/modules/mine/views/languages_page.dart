import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/app/app.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('LANGUAGES'),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile.navigation(
              title: const Text('英文'),
              trailing: Radio<String>(
                value: 'en',
                groupValue: _languageCode,
                onChanged: (String? value) {
                  setState(() {
                    _languageCode = value;
                  });
                  if (value != null) {
                    BlocProvider.of<AppCubit>(context)
                        .setLocale(Locale(value));
                  }
                },
              ),
            ),
            SettingsTile.navigation(
              title: const Text('中文'),
              trailing: Radio<String>(
                value: 'zh',
                groupValue: _languageCode,
                onChanged: (String? value) {
                  setState(() {
                    _languageCode = value;
                  });
                  if (value != null) {
                    BlocProvider.of<AppCubit>(context)
                        .setLocale(Locale(value));
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
