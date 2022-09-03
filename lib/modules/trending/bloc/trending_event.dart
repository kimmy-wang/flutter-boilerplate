part of 'trending_bloc.dart';

abstract class TrendingEvent extends Equatable {
  const TrendingEvent();
}

class TrendingSubscriptionRequested extends TrendingEvent {
  const TrendingSubscriptionRequested({
    this.operation = TrendingOperation.none,
  });

  final TrendingOperation operation;

  @override
  List<Object?> get props => [operation];
}
