part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.tabIndex = 0,
    this.refresh = false,
  });

  final int tabIndex;
  final bool refresh;

  HomeState copyWith({
    int? tabIndex,
    bool? refresh,
  }) {
    return HomeState(
      tabIndex: tabIndex ?? this.tabIndex,
      refresh: refresh ?? this.refresh,
    );
  }

  @override
  List<Object> get props => [tabIndex, refresh];
}
