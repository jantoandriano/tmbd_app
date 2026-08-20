// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenreListResponseModel _$GenreListResponseModelFromJson(
  Map<String, dynamic> json,
) => _GenreListResponseModel(
  genres: (json['genres'] as List<dynamic>)
      .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GenreListResponseModelToJson(
  _GenreListResponseModel instance,
) => <String, dynamic>{'genres': instance.genres};
