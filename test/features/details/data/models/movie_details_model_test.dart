import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _json({
  List<Map<String, dynamic>> genres = const [],
  List<Map<String, dynamic>> cast = const [],
  List<Map<String, dynamic>> videos = const [],
  bool includeCredits = true,
  bool includeVideos = true,
}) => <String, dynamic>{
  'id': 550,
  'title': 'Fight Club',
  'overview': 'An insomniac office worker...',
  'poster_path': '/poster.jpg',
  'backdrop_path': '/backdrop.jpg',
  'release_date': '1999-10-15',
  'vote_average': 8.4,
  'runtime': 139,
  'genres': genres,
  if (includeCredits) 'credits': <String, dynamic>{'cast': cast},
  if (includeVideos) 'videos': <String, dynamic>{'results': videos},
};

void main() {
  test('fromJson maps base TMDB fields', () {
    final model = MovieDetailsModel.fromJson(_json());

    expect(model.id, 550);
    expect(model.title, 'Fight Club');
    expect(model.posterPath, '/poster.jpg');
    expect(model.backdropPath, '/backdrop.jpg');
    expect(model.releaseDate, '1999-10-15');
    expect(model.voteAverage, 8.4);
    expect(model.runtime, 139);
  });

  test('toEntity maps genre names', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        genres: [
          {'id': 18, 'name': 'Drama'},
          {'id': 53, 'name': 'Thriller'},
        ],
      ),
    );

    expect(model.toEntity().genres, ['Drama', 'Thriller']);
  });

  test('toEntity sorts cast by order and caps at 10', () {
    final cast = List.generate(
      12,
      (i) => {
        'id': i,
        'name': 'Actor $i',
        'character': 'Role $i',
        'order': 11 - i,
        'profile_path': null,
      },
    );
    final model = MovieDetailsModel.fromJson(_json(cast: cast));

    final entityCast = model.toEntity().cast;

    expect(entityCast, hasLength(10));
    expect(entityCast.first.name, 'Actor 11');
    expect(entityCast.last.name, 'Actor 2');
  });

  test('toEntity prefers the official YouTube trailer', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        videos: [
          {
            'key': 'unofficial',
            'site': 'YouTube',
            'type': 'Trailer',
            'official': false,
          },
          {
            'key': 'official',
            'site': 'YouTube',
            'type': 'Trailer',
            'official': true,
          },
        ],
      ),
    );

    expect(model.toEntity().youtubeTrailerKey, 'official');
  });

  test('toEntity falls back to the first trailer when none are official', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        videos: [
          {
            'key': 'first',
            'site': 'YouTube',
            'type': 'Trailer',
            'official': false,
          },
        ],
      ),
    );

    expect(model.toEntity().youtubeTrailerKey, 'first');
  });

  test('toEntity returns a null trailer key when none match', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        videos: [
          {
            'key': 'teaser',
            'site': 'YouTube',
            'type': 'Teaser',
            'official': true,
          },
        ],
      ),
    );

    expect(model.toEntity().youtubeTrailerKey, isNull);
  });

  test('toEntity handles a response with no credits/videos keys', () {
    final model = MovieDetailsModel.fromJson(
      _json(includeCredits: false, includeVideos: false),
    );

    final entity = model.toEntity();

    expect(entity.cast, isEmpty);
    expect(entity.youtubeTrailerKey, isNull);
  });
}
