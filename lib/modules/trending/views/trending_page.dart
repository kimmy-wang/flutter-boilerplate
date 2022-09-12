import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/trending/bloc/trending_bloc.dart';
import 'package:flutter_boilerplate/modules/trending/widgets/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:trending_repository/trending_repository.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrendingBloc(
        trendingRepository: context.read<TrendingRepository>(),
      )..add(const TrendingSubscriptionRequested()),
      child: const TrendingView(),
    );
  }
}

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return _materialScaffold;
    if (Platform.isIOS) return _iosScaffold;
    if (Platform.isMacOS) return _macosScaffold;
    if (Platform.isWindows) return _windowsScaffold;
    return _materialScaffold;
  }

  Widget get _materialScaffold {
    return Scaffold(
      body: _body,
    );
  }

  Widget get _iosScaffold {
    return _body;
  }

  Widget get _windowsScaffold {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: _body,
    );
  }

  Widget get _macosScaffold {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Trending'),
        titleWidth: 150.0,
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return _body;
        })
      ],
    );
  }

  Widget get _body {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (BuildContext context, HomeState state) {
            if (state.refresh && state.tabIndex == 0) {
              _controller.callRefresh();
            }
          },
        ),
        BlocListener<TrendingBloc, TrendingState>(
          listener: (BuildContext context, TrendingState state) {
            if (state.operation == TrendingOperation.none &&
                state.status == TrendingStatus.loading) {
              EasyLoading.show();
            } else {
              Future.delayed(const Duration(milliseconds: 200), () => {
                EasyLoading.dismiss()
              });
            }

            if (state.operation == TrendingOperation.refresh) {
              if (state.status == TrendingStatus.success) {
                _controller.finishRefresh();
              } else if (state.status == TrendingStatus.failure) {
                _controller.finishRefresh(IndicatorResult.fail);
              }
            } else if (state.operation == TrendingOperation.load) {
              if (state.status == TrendingStatus.success) {
                _controller.finishLoad();
              } else if (state.status == TrendingStatus.failure) {
                _controller.finishLoad(IndicatorResult.fail);
              }
            }
          },
        )
      ],
      child: EasyRefresh(
        controller: _controller,
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        onRefresh: () async {
          context.read<TrendingBloc>().add(const TrendingSubscriptionRequested(
                operation: TrendingOperation.refresh,
              ));
        },
        onLoad: () async {
          context.read<TrendingBloc>().add(const TrendingSubscriptionRequested(
                operation: TrendingOperation.load,
              ));
        },
        child: BlocBuilder<TrendingBloc, TrendingState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.trendingList!.length,
              itemBuilder: (context, index) {
                final trending = state.trendingList![index];
                return GestureDetector(
                  onTap: () {},
                  child: RepositoryItem(
                    index: index + 1,
                    trending: trending,
                    last: index == state.trendingList!.length - 1,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
