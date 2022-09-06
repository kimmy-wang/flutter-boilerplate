import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/mine/mine.dart';
import 'package:flutter_boilerplate/modules/search/search.dart';
import 'package:flutter_boilerplate/modules/trending/trending.dart';
import 'package:macos_ui/macos_ui.dart';

const List<Module> modules = [
  Module(child: TrendingPage(), label: 'Trending', icon: Icons.trending_up),
  Module(child: SearchPage(), label: 'Search', icon: Icons.search),
  Module(child: MinePage(), label: 'Mine', icon: Icons.settings),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child:
          Platform.isMacOS ? const MacosHomeView() : const MaterialHomeView(),
    );
  }
}

/// Material
class MaterialHomeView extends StatefulWidget {
  const MaterialHomeView({super.key});

  @override
  State<MaterialHomeView> createState() => _MaterialHomeViewState();
}

class _MaterialHomeViewState extends State<MaterialHomeView>
    with TickerProviderStateMixin {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    final tabIndex = BlocProvider.of<HomeCubit>(context).state.tabIndex;
    _controller = PageController(initialPage: tabIndex);
  }

  @override
  void dispose() {
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
}

/// Macos
class MacosHomeView extends StatefulWidget {
  const MacosHomeView({super.key});

  @override
  State<MacosHomeView> createState() => _MacosHomeViewState();
}

class _MacosHomeViewState extends State<MacosHomeView> {
  late final searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [
        PlatformMenu(
          label: 'Flutter Boilerplate',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
        PlatformMenu(
          label: 'View',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
          ],
        ),
        PlatformMenu(
          label: 'Window',
          menus: [
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
          ],
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => MacosWindow(
          // titleBar: TitleBar(
          //   title: Text(modules[state.tabIndex].label),
          // ),
          sidebar: Sidebar(
            // top: MacosSearchField(
            //   placeholder: 'Search',
            //   controller: searchFieldController,
            //   onResultSelected: (result) {
            //     switch (result.searchKey) {
            //       case 'Buttons':
            //         setState(() {
            //           pageIndex = 0;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       case 'Indicators':
            //         setState(() {
            //           pageIndex = 1;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       case 'Fields':
            //         setState(() {
            //           pageIndex = 2;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       case 'Colors':
            //         setState(() {
            //           pageIndex = 3;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       case 'Dialogs and Sheets':
            //         setState(() {
            //           pageIndex = 5;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       case 'Toolbar':
            //         setState(() {
            //           pageIndex = 6;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       case 'Selectors':
            //         setState(() {
            //           pageIndex = 7;
            //           searchFieldController.clear();
            //         });
            //         break;
            //       default:
            //         searchFieldController.clear();
            //     }
            //   },
            //   results: const [
            //     SearchResultItem('Buttons'),
            //     SearchResultItem('Indicators'),
            //     SearchResultItem('Fields'),
            //   ],
            // ),
            minWidth: 200,
            builder: (context, controller) {
              return SidebarItems(
                currentIndex: state.tabIndex,
                onChanged: (index) {
                  context
                      .read<HomeCubit>()
                      .setTab(index, state.tabIndex == index);
                },
                scrollController: controller,
                itemSize: SidebarItemSize.large,
                items: modules
                    .map((module) => SidebarItem(label: Text(module.label)))
                    .toList(),
              );
            },
            // bottom: const MacosListTile(
            //   leading: MacosIcon(CupertinoIcons.profile_circled),
            //   title: Text('Tim Apple'),
            //   subtitle: Text('tim@apple.com'),
            // ),
          ),
          child: IndexedStack(
            index: state.tabIndex,
            children: modules.map((module) => module.child).toList(),
          ),
        ),
      ),
    );
  }
}
