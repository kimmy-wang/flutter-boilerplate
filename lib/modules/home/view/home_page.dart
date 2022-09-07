import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/mine/mine.dart';
import 'package:flutter_boilerplate/modules/search/search.dart';
import 'package:flutter_boilerplate/modules/trending/trending.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:window_manager/window_manager.dart';

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
      child: _child,
    );
  }

  Widget get _child {
    if (kIsWeb) return const MaterialHomeView();
    if (Platform.isMacOS) return const MacosHomeView();
    if (Platform.isWindows) return const WindowsHomeView();
    return const MaterialHomeView();
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
            top: MacosSearchField(
              placeholder: 'Search',
              controller: searchFieldController,
              onResultSelected: (result) {
                switch (result.searchKey) {
                  case 'Trending':
                    context.read<HomeCubit>().setTab(0, false);
                    setState(searchFieldController.clear);
                    break;
                  case 'Search':
                    context.read<HomeCubit>().setTab(1, false);
                    setState(searchFieldController.clear);
                    break;
                  case 'Mine':
                    context.read<HomeCubit>().setTab(2, false);
                    setState(searchFieldController.clear);
                    break;
                  default:
                    searchFieldController.clear();
                }
              },
              results: modules
                  .map((module) => SearchResultItem(module.label))
                  .toList(),
            ),
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

/// Windows
class WindowsHomeView extends StatefulWidget {
  const WindowsHomeView({super.key});

  @override
  State<WindowsHomeView> createState() => _WindowsHomeViewState();
}

class _WindowsHomeViewState extends State<WindowsHomeView> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => NavigationView(
        appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          title: DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(modules[state.tabIndex].label),
            ),
          ),
          actions: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [Spacer(), WindowButtons()],
          ),
        ),
        pane: NavigationPane(
          selected: state.tabIndex,
          onChanged: (index) {
            context.read<HomeCubit>().setTab(index, state.tabIndex == index);
          },
          size: const NavigationPaneSize(
            openMinWidth: 250,
            openMaxWidth: 320,
          ),
          // items: modules
          //     .map(
          //       (module) => PaneItem(
          //         icon: Icon(module.icon),
          //         title: Text(module.label),
          //       ),
          //     )
          //     .toList(),
          items: [
            PaneItem(icon: Icon(Icons.trending_up), title: Text('Trending')),
            PaneItem(icon: Icon(Icons.search), title: Text('Search')),
            PaneItem(icon: Icon(Icons.settings), title: Text('Mine'))
          ],
          autoSuggestBox: AutoSuggestBox(
            controller: TextEditingController(),
            items: const ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
          ),
          autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        ),
        content: NavigationBody(
          index: state.tabIndex,
          children: modules.map((module) => module.child).toList(),
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
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
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

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
