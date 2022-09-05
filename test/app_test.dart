import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/modules/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_boilerplate/modules/app/views/app.dart';
import 'package:flutter_boilerplate/theme/theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trending_repository/trending_repository.dart';

import 'helpers/helpers.dart';

void main() {
  late TrendingRepository trendingRepository;

  setUp(() {
    trendingRepository = MockTrendingRepository();
    when(
      () => trendingRepository.getTrending(),
    ).thenAnswer((_) => Future.value([]));
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          trendingRepository: trendingRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders MaterialApp with correct themes', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: trendingRepository,
          child: AppView(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, equals(FlutterBoilerplateTheme.light));
      expect(materialApp.darkTheme, equals(FlutterBoilerplateTheme.dark));
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: trendingRepository,
          child: AppView(),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
