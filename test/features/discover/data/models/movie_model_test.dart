import 'package:cinetrack/features/discover/data/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = <String, dynamic>{
    'id': 550,
    'title': 'Fight Club',
    'poster_path': '/poster.jpg',
    'vote_average': 8.4,
    'release_date': '1999-10-15',
    'overview': 'An insomniac office worker...',
  };

  test('fromJson maps TMDB snake_case fields', () {
    final model = MovieModel.fromJson(json);

    expect(model.id, 550);
    expect(model.title, 'Fight Club');
    expect(model.posterPath, '/poster.jpg');
    expect(model.voteAverage, 8.4);
    expect(model.releaseDate, '1999-10-15');
    expect(model.overview, 'An insomniac office worker...');
  });

  test('toEntity maps to the domain Movie', () {
    final entity = MovieModel.fromJson(json).toEntity();

    expect(entity.id, 550);
    expect(entity.title, 'Fight Club');
    expect(entity.posterPath, '/poster.jpg');
    expect(entity.voteAverage, 8.4);
    expect(entity.releaseDate, '1999-10-15');
    expect(entity.overview, 'An insomniac office worker...');
  });
}
