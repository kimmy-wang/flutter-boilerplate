
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void setThemeColor(int themeColor) =>
      emit(state.copyWith(themeColor: themeColor));

  void setLocale(Locale locale) =>
      emit(state.copyWith(locale: locale));

  void setThemeMode(ThemeMode themeMode) =>
      emit(state.copyWith(themeMode: themeMode));
}
