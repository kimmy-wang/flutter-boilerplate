// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_repository_middleware/local_storage_repository_middleware.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repository_middleware/repository_middleware.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageTodosApi', () {
    late SharedPreferences plugin;

    final trendingList = [
      Trending(
        author: 'author',
        name: 'name',
        avatar: 'avatar',
        url: 'url',
        description: 'description',
        stars: 0,
        forks: 0,
        currentPeriodStars: 0,
        builtBy: [
          BuiltBy(username: 'username', href: 'href', avatar: 'avatar'),
          BuiltBy(username: 'username1', href: 'href1', avatar: 'avatar1'),
        ],
      ),
      Trending(
        author: 'author1',
        name: 'name1',
        avatar: 'avatar1',
        url: 'url1',
        description: 'description1',
        stars: 10,
        forks: 10,
        currentPeriodStars: 10,
        builtBy: [
          BuiltBy(username: 'username', href: 'href', avatar: 'avatar'),
          BuiltBy(username: 'username1', href: 'href1', avatar: 'avatar1'),
        ],
      ),
    ];

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(json.encode(trendingList));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    LocalStorageRepositoryMiddleware createSubject() {
      return LocalStorageRepositoryMiddleware(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      group('initializes the todos stream', () {
        test('with existing todos if present', () {
          final subject = createSubject();

          expect(subject.get((data) => <Trending>[]), emits(trendingList));
          verify(
            () => plugin.getString(
              LocalStorageRepositoryMiddleware.kCollectionKey,
            ),
          ).called(1);
        });

        test('with empty list if no todos present', () {
          when(() => plugin.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.get((data) => <Trending>[]), emits(const <Trending>[]));
          verify(
            () => plugin.getString(
              LocalStorageRepositoryMiddleware.kCollectionKey,
            ),
          ).called(1);
        });
      });
    });

    test('getTodos returns stream of current list todos', () {
      expect(
        createSubject().get((data) => null),
        emits(trendingList),
      );
    });

    // group('saveTodo', () {
    //   test('saves new todos', () {
    //     final newTrending = Trending(
    //       author: 'author',
    //       name: 'name',
    //       avatar: 'avatar',
    //       url: 'url',
    //       description: 'description',
    //       stars: 0,
    //       forks: 0,
    //       currentPeriodStars: 0,
    //       builtBy: [
    //         BuiltBy(username: 'username', href: 'href', avatar: 'avatar'),
    //         BuiltBy(username: 'username1', href: 'href1', avatar: 'avatar1'),
    //       ],
    //     );
    //
    //     final newTrendingList = [...trendingList, newTrending];
    //
    //     final subject = createSubject();
    //
    //     expect(subject.save(newTrendingList), completes);
    //     expect(subject.get(converter), emits(newTrendingList));
    //
    //     verify(
    //       () => plugin.setString(
    //         LocalStorageRepositoryMiddleware.kCollectionKey,
    //         json.encode(newTrendingList),
    //       ),
    //     ).called(1);
    //   });
    // });
  });
}
