
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/home/view/drawer_page.dart';

/// web
class WebHomeView extends StatelessWidget {
  const WebHomeView({super.key, required this.modules});

  final List<Module> modules;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => Scaffold(
        drawer: DrawerPage(modules: modules),
        appBar: AppBar(
          title: Text(modules[state.tabIndex].label),
          centerTitle: true,
        ),
        body: modules[state.tabIndex].child,
      ),
    );
  }
}
