import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_boilerplate/modules/trending/bloc/trending_bloc.dart';
import 'package:flutter_boilerplate/modules/trending/widgets/widgets.dart';
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
    return Scaffold(
      body: MultiBlocListener(
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
            context
                .read<TrendingBloc>()
                .add(const TrendingSubscriptionRequested(
                  operation: TrendingOperation.refresh,
                ));
          },
          onLoad: () async {
            context
                .read<TrendingBloc>()
                .add(const TrendingSubscriptionRequested(
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
      ),
    );
  }
}
