// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenreModel _$GenreModelFromJson(Map<String, dynamic> json) =>
    _GenreModel(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$GenreModelToJson(_GenreModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_CastMemberModel _$CastMemberModelFromJson(Map<String, dynamic> json) =>
    _CastMemberModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      character: json['character'] as String,
      order: (json['order'] as num).toInt(),
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$CastMemberModelToJson(_CastMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'character': instance.character,
      'order': instance.order,
      'profile_path': instance.profilePath,
    };

_CreditsModel _$CreditsModelFromJson(Map<String, dynamic> json) =>
    _CreditsModel(
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CastMemberModel>[],
    );

Map<String, dynamic> _$CreditsModelToJson(_CreditsModel instance) =>
    <String, dynamic>{'cast': instance.cast};

_VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => _VideoModel(
  key: json['key'] as String,
  site: json['site'] as String,
  type: json['type'] as String,
  official: json['official'] as bool? ?? false,
);

Map<String, dynamic> _$VideoModelToJson(_VideoModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'site': instance.site,
      'type': instance.type,
      'official': instance.official,
    };

_VideosResponseModel _$VideosResponseModelFromJson(Map<String, dynamic> json) =>
    _VideosResponseModel(
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VideoModel>[],
    );

Map<String, dynamic> _$VideosResponseModelToJson(
  _VideosResponseModel instance,
) => <String, dynamic>{'results': instance.results};

_MovieDetailsModel _$MovieDetailsModelFromJson(Map<String, dynamic> json) =>
    _MovieDetailsModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GenreModel>[],
      credits: json['credits'] == null
          ? null
          : CreditsModel.fromJson(json['credits'] as Map<String, dynamic>),
      videos: json['videos'] == null
          ? null
          : VideosResponseModel.fromJson(
              json['videos'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MovieDetailsModelToJson(_MovieDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'runtime': instance.runtime,
      'genres': instance.genres,
      'credits': instance.credits,
      'videos': instance.videos,
    };
