import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchView();
  }
}

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isMacOS
        ? _macosScaffold(context)
        : Scaffold(
            body: _body,
          );
  }

  Widget _macosScaffold(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Search'),
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
    return const Center(
      child: Text('Search'),
    );
  }
}
