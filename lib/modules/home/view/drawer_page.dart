import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.secondary;
    return Drawer(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => Column(
          children: [
            Container(
              height: kToolbarHeight,
              color: primaryColor,
            ),
            ...menus(context, state.tabIndex),
          ],
        ),
      ),
    );
  }

  List<Widget> menus(BuildContext context, int currentIndex) {
    var _menus = <Widget>[];
    modules.asMap().forEach((index, module) {
      _menus.add(ListTile(
        leading: Icon(module.icon),
        title: Text(module.label),
        onTap: () {
          context.read<HomeCubit>().setTab(index, currentIndex == index);
        },
      ));
    });
    return _menus;
  }
}
