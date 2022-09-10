import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/home/view/home_page/platforms.dart';
import 'package:flutter_boilerplate/modules/mine/mine.dart';
import 'package:flutter_boilerplate/modules/search/search.dart';
import 'package:flutter_boilerplate/modules/trending/trending.dart';

const List<Module> modules = [
  Module(child: TrendingPage(), label: 'Trending', icon: Icons.trending_up),
  Module(child: SearchPage(), label: 'Search', icon: Icons.search),
  Module(child: MinePage(), label: 'Mine', icon: Icons.settings),
];

final List<String> moduleNames = modules.map((module) => module.label).toList();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: _child,
    );
  }

  Widget get _child {
    if (kIsWeb) return const WebHomeView();
    if (Platform.isIOS) return const IOSHomeView();
    if (Platform.isMacOS) return const MacosHomeView();
    if (Platform.isWindows) return const WindowsHomeView();
    if (Platform.isLinux) return const LinuxHomeView();
    return const MaterialHomeView();
  }
}


