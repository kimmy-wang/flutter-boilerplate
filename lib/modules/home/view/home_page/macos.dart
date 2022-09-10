import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:window_manager/window_manager.dart';

/// Macos
class MacosHomeView extends StatefulWidget {
  const MacosHomeView({super.key});

  @override
  State<MacosHomeView> createState() => _MacosHomeViewState();
}

class _MacosHomeViewState extends State<MacosHomeView> with WindowListener {
  final searchFieldController = TextEditingController();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchFieldController.dispose();
    super.dispose();
  }

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
                final idx = moduleNames.indexOf(result.searchKey);
                if (idx >= 0) {
                  context.read<HomeCubit>().setTab(idx, false);
                  setState(searchFieldController.clear);
                  return;
                }
                searchFieldController.clear();
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

  @override
  Future<void> onWindowClose() async {
    final _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      await showCupertinoDialog(
        context: context,
        builder: (_) {
          return MacosAlertDialog(
            message: const Text('Are you sure you want to close this window?'),
            primaryButton: PushButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              buttonSize: ButtonSize.large,
              child: const Text('No'),
            ),
            secondaryButton: PushButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await windowManager.destroy();
              },
              buttonSize: ButtonSize.large,
              isSecondary: true,
              child: const Text('Yes'),
            ),
            title: const Text('Confirm close'),
            appIcon: const MacosIcon(CupertinoIcons.info),
          );
        },
      );
    }
  }
}
