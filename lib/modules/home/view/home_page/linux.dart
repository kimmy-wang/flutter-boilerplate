
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:window_manager/window_manager.dart';

/// linux
class LinuxHomeView extends StatefulWidget {
  const LinuxHomeView({super.key});

  @override
  State<LinuxHomeView> createState() => _LinuxHomeViewState();
}

class _LinuxHomeViewState extends State<LinuxHomeView>
    with TickerProviderStateMixin, WindowListener {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    final tabIndex = BlocProvider.of<HomeCubit>(context).state.tabIndex;
    _controller = PageController(initialPage: tabIndex);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(modules[state.tabIndex].label),
          centerTitle: true,
        ),
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: modules.map((module) => module.child).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          currentIndex: state.tabIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            context.read<HomeCubit>().setTab(index, state.tabIndex == index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: secondaryColor,
          items: modules
              .map(
                (module) => BottomNavigationBarItem(
              label: module.label,
              icon: Icon(module.icon),
              activeIcon: Icon(module.icon, color: secondaryColor),
            ),
          )
              .toList(),
        ),
      ),
    );
  }

  @override
  Future<void> onWindowClose() async {
    final _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
