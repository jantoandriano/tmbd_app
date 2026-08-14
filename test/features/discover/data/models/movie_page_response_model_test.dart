import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson maps page, results, and total_pages', () {
    final json = <String, dynamic>{
      'page': 1,
      'results': <Map<String, dynamic>>[
        {
          'id': 1,
          'title': 'A',
          'poster_path': null,
          'vote_average': 5.0,
          'release_date': null,
          'overview': '',
        },
      ],
      'total_pages': 500,
      'total_results': 10000,
    };

    final model = MoviePageResponseModel.fromJson(json);

    expect(model.page, 1);
    expect(model.results, hasLength(1));
    expect(model.results.first.title, 'A');
    expect(model.totalPages, 500);
  });
}
