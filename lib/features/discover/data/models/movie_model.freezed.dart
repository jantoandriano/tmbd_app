// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieModel {

 int get id; String get title;@JsonKey(name: 'vote_average') double get voteAverage; String get overview;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'release_date') String? get releaseDate;
/// Create a copy of MovieModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieModelCopyWith<MovieModel> get copyWith => _$MovieModelCopyWithImpl<MovieModel>(this as MovieModel, _$identity);

  /// Serializes this MovieModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,voteAverage,overview,posterPath,releaseDate);

@override
String toString() {
  return 'MovieModel(id: $id, title: $title, voteAverage: $voteAverage, overview: $overview, posterPath: $posterPath, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class $MovieModelCopyWith<$Res>  {
  factory $MovieModelCopyWith(MovieModel value, $Res Function(MovieModel) _then) = _$MovieModelCopyWithImpl;
@useResult
$Res call({
 int id, String title,@JsonKey(name: 'vote_average') double voteAverage, String overview,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'release_date') String? releaseDate
});




}
/// @nodoc
class _$MovieModelCopyWithImpl<$Res>
    implements $MovieModelCopyWith<$Res> {
  _$MovieModelCopyWithImpl(this._self, this._then);

  final MovieModel _self;
  final $Res Function(MovieModel) _then;

/// Create a copy of MovieModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? voteAverage = null,Object? overview = null,Object? posterPath = freezed,Object? releaseDate = freezed,}) {
  return _then(MovieModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieModel].
extension MovieModelPatterns on MovieModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieModel value)  $default,){
final _that = this;
switch (_that) {
case _MovieModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieModel value)?  $default,){
final _that = this;
switch (_that) {
case _MovieModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title, @JsonKey(name: 'vote_average')  double voteAverage,  String overview, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'release_date')  String? releaseDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieModel() when $default != null:
return $default(_that.id,_that.title,_that.voteAverage,_that.overview,_that.posterPath,_that.releaseDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title, @JsonKey(name: 'vote_average')  double voteAverage,  String overview, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'release_date')  String? releaseDate)  $default,) {final _that = this;
switch (_that) {
case _MovieModel():
return $default(_that.id,_that.title,_that.voteAverage,_that.overview,_that.posterPath,_that.releaseDate);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title, @JsonKey(name: 'vote_average')  double voteAverage,  String overview, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'release_date')  String? releaseDate)?  $default,) {final _that = this;
switch (_that) {
case _MovieModel() when $default != null:
return $default(_that.id,_that.title,_that.voteAverage,_that.overview,_that.posterPath,_that.releaseDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovieModel extends MovieModel {
  const _MovieModel({required this.id, required this.title, @JsonKey(name: 'vote_average') required this.voteAverage, required this.overview, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'release_date') this.releaseDate}): super._();
  factory _MovieModel.fromJson(Map<String, dynamic> json) => _$MovieModelFromJson(json);

@override final  int id;
@override final  String title;
@override@JsonKey(name: 'vote_average') final  double voteAverage;
@override final  String overview;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'release_date') final  String? releaseDate;

/// Create a copy of MovieModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieModelCopyWith<_MovieModel> get copyWith => __$MovieModelCopyWithImpl<_MovieModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,voteAverage,overview,posterPath,releaseDate);

@override
String toString() {
  return 'MovieModel(id: $id, title: $title, voteAverage: $voteAverage, overview: $overview, posterPath: $posterPath, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class _$MovieModelCopyWith<$Res> implements $MovieModelCopyWith<$Res> {
  factory _$MovieModelCopyWith(_MovieModel value, $Res Function(_MovieModel) _then) = __$MovieModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title,@JsonKey(name: 'vote_average') double voteAverage, String overview,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'release_date') String? releaseDate
});




}
/// @nodoc
class __$MovieModelCopyWithImpl<$Res>
    implements _$MovieModelCopyWith<$Res> {
  __$MovieModelCopyWithImpl(this._self, this._then);

  final _MovieModel _self;
  final $Res Function(_MovieModel) _then;

/// Create a copy of MovieModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? voteAverage = null,Object? overview = null,Object? posterPath = freezed,Object? releaseDate = freezed,}) {
  return _then(_MovieModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
