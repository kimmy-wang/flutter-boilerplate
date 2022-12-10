///
typedef ModelConverter<T> = T Function(dynamic data);

/// {@template trending_repository_middleware}
/// A repository that handles trending related requests.
/// {@endtemplate}
abstract class RepositoryMiddleware {
  /// {@macro trending_repository_middleware}
  const RepositoryMiddleware();

  /// Provides a [Future] of all trending.
  Future<T> get<T>(
    ModelConverter<T> converter, {
    String? suffix,
  });

  ///
  Future<void> save<T>(T data, {String? suffix});
}
