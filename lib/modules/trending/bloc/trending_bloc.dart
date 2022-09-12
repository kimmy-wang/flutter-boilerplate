import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trending_repository/trending_repository.dart';

part 'trending_event.dart';

part 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  TrendingBloc({
    required TrendingRepository trendingRepository,
  })  : _trendingRepository = trendingRepository,
        super(const TrendingState()) {
    on<TrendingSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TrendingRepository _trendingRepository;

  Future<void> _onSubscriptionRequested(
    TrendingSubscriptionRequested event,
    Emitter<TrendingState> emit,
  ) async {
    emit(state.copyWith(
      status: TrendingStatus.loading,
      operation: event.operation,
    ));

    var page = state.page;
    final pullDown = event.operation == TrendingOperation.refresh;
    final loadMore = event.operation == TrendingOperation.load;
    if (pullDown) {
      page = 1;
    } else if (loadMore) {
      page++;
    }

    await emit.forEach<List<Trending>?>(
      _trendingRepository
          .getTrending(pullDown: pullDown, loadMore: loadMore, page: page)
          .asStream(),
      onData: (trendingList) {
        var newTrendingList = state.trendingList;
        if (loadMore) {
          newTrendingList?.addAll(trendingList ?? []);
        } else {
          newTrendingList = trendingList;
        }
        return state.copyWith(
          status: TrendingStatus.success,
          page: page,
          trendingList: newTrendingList,
        );
      },
      onError: (_, __) => state.copyWith(
        status: TrendingStatus.failure,
      ),
    );
  }
}
