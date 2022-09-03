import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/mine/mine.dart';
import 'package:flutter_boilerplate/modules/search/search.dart';
import 'package:flutter_boilerplate/modules/trending/trending.dart';

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
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
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
