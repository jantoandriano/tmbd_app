// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoviePageResponseModel _$MoviePageResponseModelFromJson(
  Map<String, dynamic> json,
) => _MoviePageResponseModel(
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$MoviePageResponseModelToJson(
  _MoviePageResponseModel instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results,
  'total_pages': instance.totalPages,
};
