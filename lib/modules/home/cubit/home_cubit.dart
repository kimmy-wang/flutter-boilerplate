import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(int tabIndex, bool refresh) =>
      emit(HomeState(tabIndex: tabIndex, refresh: refresh));

  void setDisplayMode(DisplayMode displayMode) =>
      emit(state.copyWith(displayMode: displayMode));
}
