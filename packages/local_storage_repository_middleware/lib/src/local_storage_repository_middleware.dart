import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:repository_middleware/repository_middleware.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trending_common/trending_common.dart';

/// {@template local_storage_repository_middleware}
/// A Flutter implementation of the [RepositoryMiddleware] that uses local storage.
/// {@endtemplate}
class LocalStorageRepositoryMiddleware extends RepositoryMiddleware {
  /// {@macro local_storage_repository_middleware}
  LocalStorageRepositoryMiddleware({
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  final SharedPreferences _plugin;

  /// The key used for storing the trending locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kCollectionKey = '__collection_key__';

  ///
  static String mCollectionKey({String? suffix}) {
    return '$kCollectionKey${suffix == null ? '' : '${suffix}__'}';
  }

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  @override
  Future<T> get<T>(
    ModelConverter<T> converter, {
    String? suffix,
  }) async {
    final jsonStr = _getValue(mCollectionKey(suffix: suffix));
    return converter(jsonStr == null ? null : json.decode(jsonStr));
  }

  @override
  Future<void> save<T>(T data, {String? suffix}) {
    return _setValue(mCollectionKey(suffix: suffix), json.encode(data));
  }
}
