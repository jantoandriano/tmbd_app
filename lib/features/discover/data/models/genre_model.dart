import 'package:cinetrack/features/discover/domain/entities/genre.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_model.freezed.dart';
part 'genre_model.g.dart';

@freezed
sealed class GenreModel with _$GenreModel {
  const factory GenreModel({required int id, required String name}) =
      _GenreModel;

  const GenreModel._();

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Genre toEntity() => Genre(id: id, name: name);
}
