import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';

/// web
class WebHomeView extends StatefulWidget {
  const WebHomeView({super.key});

  @override
  State<WebHomeView> createState() => _WebHomeViewState();
}

class _WebHomeViewState extends State<WebHomeView> with SingleTickerProviderStateMixin {

  // Animation controller
  late AnimationController _animationController;

  // This is used to animate the icon of the main FAB
  late Animation<double> _buttonAnimatedIcon;

  // This is used for the child FABs
  late Animation<double> _translateButton;

  // This variable determnies whether the child FABs are visible or not
  bool _isExpanded = false;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    _buttonAnimatedIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: 100,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  // dispose the animation controller
  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // This function is used to expand/collapse the children floating buttons
  // It will be called when the primary FAB (with menu icon) is pressed
  void _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.secondary;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => Scaffold(
        // drawer: DrawerPage(),
        // appBar: AppBar(
        //   title: Text(modules[state.tabIndex].label),
        //   centerTitle: true,
        // ),
        body: Title(
          title: modules[state.tabIndex].label,
          color: primaryColor,
          child: modules[state.tabIndex].child,
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...menus(state.tabIndex),
            // This is the primary FAB
            FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: _toggle,
              child: AnimatedIcon(
                color: primaryColor,
                icon: AnimatedIcons.menu_close,
                progress: _buttonAnimatedIcon,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  List<Widget> menus(int currentIndex) {
    final _menus = <Widget>[];
    modules.asMap().forEach((index, module) {
      _menus.add(Transform(
        transform: Matrix4.translationValues(
          0,
          _translateButton.value * (4 - index),
          0,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            context.read<HomeCubit>().setTab(index, currentIndex == index);
          },
          child: Icon(
            module.icon,
          ),
        ),
      ));
    });
    return _menus;
  }
}
