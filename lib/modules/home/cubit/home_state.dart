part of 'home_cubit.dart';

enum DisplayMode { compact, open }

class HomeState extends Equatable {
  const HomeState({
    this.tabIndex = 0,
    this.refresh = false,
    this.displayMode = DisplayMode.compact,
  });

  final int tabIndex;
  final bool refresh;
  final DisplayMode displayMode;

  HomeState copyWith({
    int? tabIndex,
    bool? refresh,
    DisplayMode? displayMode,
  }) {
    return HomeState(
      tabIndex: tabIndex ?? this.tabIndex,
      refresh: refresh ?? this.refresh,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  @override
  List<Object> get props => [tabIndex, refresh, displayMode];
}
