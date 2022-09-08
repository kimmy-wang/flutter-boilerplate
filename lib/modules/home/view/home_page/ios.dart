import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';

/// ios
class IOSHomeView extends StatefulWidget {
  const IOSHomeView({super.key});

  @override
  State<IOSHomeView> createState() => _IOSHomeViewState();
}

class _IOSHomeViewState extends State<IOSHomeView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => CupertinoTabScaffold(
        // appBar: AppBar(
        //   title: Text(modules[state.tabIndex].label),
        //   centerTitle: true,
        // ),
        // body: PageView(
        //   controller: _controller,
        //   physics: const NeverScrollableScrollPhysics(),
        //   children: modules.map((module) => module.child).toList(),
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   selectedFontSize: 12,
        //   currentIndex: state.tabIndex,
        //   onTap: (index) {
        //     _controller.jumpToPage(index);
        //     context.read<HomeCubit>().setTab(index, state.tabIndex == index);
        //   },
        //   type: BottomNavigationBarType.fixed,
        //   selectedItemColor: primaryColor,
        //   items: modules
        //       .map(
        //         (module) => BottomNavigationBarItem(
        //           label: module.label,
        //           icon: Icon(module.icon),
        //           activeIcon: Icon(module.icon, color: primaryColor),
        //         ),
        //       )
        //       .toList(),
        // ),
        tabBar: CupertinoTabBar(
          currentIndex: state.tabIndex,
          onTap: (index) {
            context.read<HomeCubit>().setTab(index, state.tabIndex == index);
          },
          items: modules
              .map(
                (module) => BottomNavigationBarItem(
                  label: module.label,
                  icon: Icon(module.icon),
                  activeIcon: Icon(module.icon, color: primaryColor),
                ),
              )
              .toList(),
        ),
        tabBuilder: (BuildContext context, int index) => CupertinoTabView(
          defaultTitle: modules[index].label,
          builder: (_) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(modules[index].label),
            ),
            child: SafeArea(child: modules[index].child),
          ),
        ),
      ),
    );
  }
}
