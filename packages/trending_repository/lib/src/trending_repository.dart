import 'package:repository_middleware/repository_middleware.dart';
import 'package:trending_api/trending_api.dart';

/// {@template trending_repository}
/// A repository that handles trending related requests.
/// {@endtemplate}
class TrendingRepository {
  /// {@macro trending_repository}
  const TrendingRepository({
    required TrendingApi trendingApi,
    RepositoryMiddleware? repositoryMiddleware,
  })  : _trendingApi = trendingApi,
        _repositoryMiddleware = repositoryMiddleware;

  final TrendingApi _trendingApi;
  final RepositoryMiddleware? _repositoryMiddleware;

  /// Provides a [Future] of all trending.
  Future<List<Trending>?> getTrending({
    bool pullDown = false,
    bool loadMore = false,
    int page = 1,
    int pageSize = 25,
  }) async {
    List<Trending>? trendingList;
    final suffix = loadMore ? '${page}_$pageSize' : null;
    if (_repositoryMiddleware != null && !pullDown) {
      List<Trending>? trendingConverter(dynamic jsonStr) {
        if (jsonStr != null) {
          return List<Map<String, dynamic>>.from(
            jsonStr as Iterable,
          )
              .map(
                (jsonMap) => Trending.fromJson(
                  Map<String, dynamic>.from(jsonMap),
                ),
              )
              .toList();
        }
        return null;
      }

      trendingList = await _repositoryMiddleware!.get<List<Trending>?>(
        trendingConverter,
        suffix: suffix,
      );
    }
    if (trendingList == null || trendingList.isEmpty) {
      trendingList = await _trendingApi.getTrending(
        page: page,
        pageSize: pageSize,
      );
    }
    if (_repositoryMiddleware != null &&
        trendingList != null &&
        trendingList.isNotEmpty) {
      await _repositoryMiddleware!.save(trendingList, suffix: suffix);
    }
    return trendingList;
  }
}
