import 'package:cinetrack/features/discover/data/models/genre_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_list_response_model.freezed.dart';
part 'genre_list_response_model.g.dart';

@freezed
sealed class GenreListResponseModel with _$GenreListResponseModel {
  const factory GenreListResponseModel({required List<GenreModel> genres}) =
      _GenreListResponseModel;

  factory GenreListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GenreListResponseModelFromJson(json);
}
