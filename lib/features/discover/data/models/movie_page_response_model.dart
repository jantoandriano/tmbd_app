import 'package:cinetrack/features/discover/data/models/movie_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_page_response_model.freezed.dart';
part 'movie_page_response_model.g.dart';

@freezed
sealed class MoviePageResponseModel with _$MoviePageResponseModel {
  const factory MoviePageResponseModel({
    required int page,
    required List<MovieModel> results,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _MoviePageResponseModel;

  factory MoviePageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoviePageResponseModelFromJson(json);
}
