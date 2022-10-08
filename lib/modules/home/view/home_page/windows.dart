import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:window_manager/window_manager.dart';

/// Windows
class WindowsHomeView extends StatefulWidget {
  const WindowsHomeView({super.key});

  @override
  State<WindowsHomeView> createState() => _WindowsHomeViewState();
}

class _WindowsHomeViewState extends State<WindowsHomeView> with WindowListener {
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
          displayMode: state.displayMode == DisplayMode.compact
              ? PaneDisplayMode.compact
              : PaneDisplayMode.open,
          menuButton: Center(
            child: IconButton(
              onPressed: () {
                final displayMode = state.displayMode == DisplayMode.compact
                    ? DisplayMode.open
                    : DisplayMode.compact;
                BlocProvider.of<HomeCubit>(context).setDisplayMode(displayMode);
              },
              icon: const Icon(FluentIcons.collapse_menu),
            ),
          ),
          selected: state.tabIndex,
          onChanged: (index) {
            context.read<HomeCubit>().setTab(index, state.tabIndex == index);
          },
          size: const NavigationPaneSize(
            openMinWidth: 250,
            openMaxWidth: 320,
          ),
          items: modules
              .map(
                (module) => PaneItem(
              icon: Icon(module.icon),
              title: Text(module.label),
            ),
          )
              .toList()
              .cast<NavigationPaneItem>(),
          // items: [
          //   PaneItem(icon: Icon(FluentIcons.up), title: Text('Trending')),
          //   PaneItem(icon: Icon(FluentIcons.search), title: Text('Search')),
          //   PaneItem(icon: Icon(FluentIcons.settings), title: Text('Mine'))
          // ],
          autoSuggestBox: AutoSuggestBox(
            controller: searchFieldController,
            items: moduleNames,
            onSelected: (value) {
              final idx = moduleNames.indexOf(value);
              if (idx >= 0) {
                context.read<HomeCubit>().setTab(idx, false);
                setState(searchFieldController.clear);
                return;
              }
              searchFieldController.clear();
            },
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
