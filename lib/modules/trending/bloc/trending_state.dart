part of 'trending_bloc.dart';

enum TrendingStatus { initial, loading, success, failure }

enum TrendingOperation { none, refresh, load }

class TrendingState extends Equatable {
  const TrendingState({
    this.status = TrendingStatus.initial,
    this.operation = TrendingOperation.none,
    this.page = 1,
    this.trendingList = const [],
  });

  final TrendingStatus status;
  final TrendingOperation operation;
  final int page;
  final List<Trending>? trendingList;

  TrendingState copyWith({
    TrendingStatus? status,
    TrendingOperation? operation,
    int? page,
    List<Trending>? trendingList,
  }) {
    return TrendingState(
      status: status ?? this.status,
      operation: operation ?? this.operation,
      page: page ?? this.page,
      trendingList: trendingList ?? this.trendingList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        operation,
        page,
        trendingList,
      ];
}
