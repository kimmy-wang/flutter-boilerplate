import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:trending_api/trending_api.dart';

/// {@template http_trending_api}
/// A Flutter implementation of the [TrendingApi] that uses http.
/// {@endtemplate}
class HttpTrendingApi extends TrendingApi {
  /// {@macro http_trending_api}
  HttpTrendingApi({
    required http.Client client,
  }) : _client = client;

  final http.Client _client;

  @override
  Future<List<Trending>?> getTrending({
    required int page,
    required int pageSize,
  }) async {
    try {
      final res = await _client.get(Uri.parse('https://api.github.com/'));
      if (res.statusCode == 200) {
        return List<Trending>.from(
            (convert.jsonDecode(res.body) as Iterable).map(
          (x) => Trending.fromJson(x as Map<String, dynamic>),
        ));
      }
      return [];
    } on Exception catch (error, stack) {
      throw TrendingRequestedException();
    }
  }
}
