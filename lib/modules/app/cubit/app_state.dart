part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.themeColor = 0xFF13B9FF,
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
  });

  final int themeColor;
  final Locale locale;
  final ThemeMode themeMode;

  AppState copyWith({
    int? themeColor,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppState(
      themeColor: themeColor ?? this.themeColor,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeColor, locale, themeMode];
}
