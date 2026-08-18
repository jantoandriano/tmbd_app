// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieDetails {

 int get id; String get title; String get overview; double get voteAverage; String? get posterPath; String? get backdropPath; String? get releaseDate; int? get runtimeMinutes; List<String> get genres; List<CastMember> get cast; String? get youtubeTrailerKey;
/// Create a copy of MovieDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailsCopyWith<MovieDetails> get copyWith => _$MovieDetailsCopyWithImpl<MovieDetails>(this as MovieDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtimeMinutes, runtimeMinutes) || other.runtimeMinutes == runtimeMinutes)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.cast, cast)&&(identical(other.youtubeTrailerKey, youtubeTrailerKey) || other.youtubeTrailerKey == youtubeTrailerKey));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,overview,voteAverage,posterPath,backdropPath,releaseDate,runtimeMinutes,const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(cast),youtubeTrailerKey);

@override
String toString() {
  return 'MovieDetails(id: $id, title: $title, overview: $overview, voteAverage: $voteAverage, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, runtimeMinutes: $runtimeMinutes, genres: $genres, cast: $cast, youtubeTrailerKey: $youtubeTrailerKey)';
}


}

/// @nodoc
abstract mixin class $MovieDetailsCopyWith<$Res>  {
  factory $MovieDetailsCopyWith(MovieDetails value, $Res Function(MovieDetails) _then) = _$MovieDetailsCopyWithImpl;
@useResult
$Res call({
 int id, String title, String overview, double voteAverage, String? posterPath, String? backdropPath, String? releaseDate, int? runtimeMinutes, List<String> genres, List<CastMember> cast, String? youtubeTrailerKey
});




}
/// @nodoc
class _$MovieDetailsCopyWithImpl<$Res>
    implements $MovieDetailsCopyWith<$Res> {
  _$MovieDetailsCopyWithImpl(this._self, this._then);

  final MovieDetails _self;
  final $Res Function(MovieDetails) _then;

/// Create a copy of MovieDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? overview = null,Object? voteAverage = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,Object? runtimeMinutes = freezed,Object? genres = null,Object? cast = null,Object? youtubeTrailerKey = freezed,}) {
  return _then(MovieDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,runtimeMinutes: freezed == runtimeMinutes ? _self.runtimeMinutes : runtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMember>,youtubeTrailerKey: freezed == youtubeTrailerKey ? _self.youtubeTrailerKey : youtubeTrailerKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieDetails].
extension MovieDetailsPatterns on MovieDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieDetails value)  $default,){
final _that = this;
switch (_that) {
case _MovieDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieDetails value)?  $default,){
final _that = this;
switch (_that) {
case _MovieDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String overview,  double voteAverage,  String? posterPath,  String? backdropPath,  String? releaseDate,  int? runtimeMinutes,  List<String> genres,  List<CastMember> cast,  String? youtubeTrailerKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieDetails() when $default != null:
return $default(_that.id,_that.title,_that.overview,_that.voteAverage,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtimeMinutes,_that.genres,_that.cast,_that.youtubeTrailerKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String overview,  double voteAverage,  String? posterPath,  String? backdropPath,  String? releaseDate,  int? runtimeMinutes,  List<String> genres,  List<CastMember> cast,  String? youtubeTrailerKey)  $default,) {final _that = this;
switch (_that) {
case _MovieDetails():
return $default(_that.id,_that.title,_that.overview,_that.voteAverage,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtimeMinutes,_that.genres,_that.cast,_that.youtubeTrailerKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String overview,  double voteAverage,  String? posterPath,  String? backdropPath,  String? releaseDate,  int? runtimeMinutes,  List<String> genres,  List<CastMember> cast,  String? youtubeTrailerKey)?  $default,) {final _that = this;
switch (_that) {
case _MovieDetails() when $default != null:
return $default(_that.id,_that.title,_that.overview,_that.voteAverage,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtimeMinutes,_that.genres,_that.cast,_that.youtubeTrailerKey);case _:
  return null;

}
}

}

/// @nodoc


class _MovieDetails implements MovieDetails {
  const _MovieDetails({required this.id, required this.title, required this.overview, required this.voteAverage, this.posterPath, this.backdropPath, this.releaseDate, this.runtimeMinutes,  List<String> genres = const <String>[],  List<CastMember> cast = const <CastMember>[], this.youtubeTrailerKey}): _genres = genres,_cast = cast;
  

@override final  int id;
@override final  String title;
@override final  String overview;
@override final  double voteAverage;
@override final  String? posterPath;
@override final  String? backdropPath;
@override final  String? releaseDate;
@override final  int? runtimeMinutes;
 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<CastMember> _cast;
@override@JsonKey() List<CastMember> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

@override final  String? youtubeTrailerKey;

/// Create a copy of MovieDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailsCopyWith<_MovieDetails> get copyWith => __$MovieDetailsCopyWithImpl<_MovieDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtimeMinutes, runtimeMinutes) || other.runtimeMinutes == runtimeMinutes)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._cast, _cast)&&(identical(other.youtubeTrailerKey, youtubeTrailerKey) || other.youtubeTrailerKey == youtubeTrailerKey));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,overview,voteAverage,posterPath,backdropPath,releaseDate,runtimeMinutes,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_cast),youtubeTrailerKey);

@override
String toString() {
  return 'MovieDetails(id: $id, title: $title, overview: $overview, voteAverage: $voteAverage, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, runtimeMinutes: $runtimeMinutes, genres: $genres, cast: $cast, youtubeTrailerKey: $youtubeTrailerKey)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailsCopyWith<$Res> implements $MovieDetailsCopyWith<$Res> {
  factory _$MovieDetailsCopyWith(_MovieDetails value, $Res Function(_MovieDetails) _then) = __$MovieDetailsCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String overview, double voteAverage, String? posterPath, String? backdropPath, String? releaseDate, int? runtimeMinutes, List<String> genres, List<CastMember> cast, String? youtubeTrailerKey
});




}
/// @nodoc
class __$MovieDetailsCopyWithImpl<$Res>
    implements _$MovieDetailsCopyWith<$Res> {
  __$MovieDetailsCopyWithImpl(this._self, this._then);

  final _MovieDetails _self;
  final $Res Function(_MovieDetails) _then;

/// Create a copy of MovieDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? overview = null,Object? voteAverage = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,Object? runtimeMinutes = freezed,Object? genres = null,Object? cast = null,Object? youtubeTrailerKey = freezed,}) {
  return _then(_MovieDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,runtimeMinutes: freezed == runtimeMinutes ? _self.runtimeMinutes : runtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMember>,youtubeTrailerKey: freezed == youtubeTrailerKey ? _self.youtubeTrailerKey : youtubeTrailerKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CastMember {

 int get id; String get name; String get character; String? get profilePath;
/// Create a copy of CastMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CastMemberCopyWith<CastMember> get copyWith => _$CastMemberCopyWithImpl<CastMember>(this as CastMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CastMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.character, character) || other.character == character)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,character,profilePath);

@override
String toString() {
  return 'CastMember(id: $id, name: $name, character: $character, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $CastMemberCopyWith<$Res>  {
  factory $CastMemberCopyWith(CastMember value, $Res Function(CastMember) _then) = _$CastMemberCopyWithImpl;
@useResult
$Res call({
 int id, String name, String character, String? profilePath
});




}
/// @nodoc
class _$CastMemberCopyWithImpl<$Res>
    implements $CastMemberCopyWith<$Res> {
  _$CastMemberCopyWithImpl(this._self, this._then);

  final CastMember _self;
  final $Res Function(CastMember) _then;

/// Create a copy of CastMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? character = null,Object? profilePath = freezed,}) {
  return _then(CastMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CastMember].
extension CastMemberPatterns on CastMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CastMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CastMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CastMember value)  $default,){
final _that = this;
switch (_that) {
case _CastMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CastMember value)?  $default,){
final _that = this;
switch (_that) {
case _CastMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String character,  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CastMember() when $default != null:
return $default(_that.id,_that.name,_that.character,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String character,  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _CastMember():
return $default(_that.id,_that.name,_that.character,_that.profilePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String character,  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _CastMember() when $default != null:
return $default(_that.id,_that.name,_that.character,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc


class _CastMember implements CastMember {
  const _CastMember({required this.id, required this.name, required this.character, this.profilePath});
  

@override final  int id;
@override final  String name;
@override final  String character;
@override final  String? profilePath;

/// Create a copy of CastMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CastMemberCopyWith<_CastMember> get copyWith => __$CastMemberCopyWithImpl<_CastMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CastMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.character, character) || other.character == character)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,character,profilePath);

@override
String toString() {
  return 'CastMember(id: $id, name: $name, character: $character, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$CastMemberCopyWith<$Res> implements $CastMemberCopyWith<$Res> {
  factory _$CastMemberCopyWith(_CastMember value, $Res Function(_CastMember) _then) = __$CastMemberCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String character, String? profilePath
});




}
/// @nodoc
class __$CastMemberCopyWithImpl<$Res>
    implements _$CastMemberCopyWith<$Res> {
  __$CastMemberCopyWithImpl(this._self, this._then);

  final _CastMember _self;
  final $Res Function(_CastMember) _then;

/// Create a copy of CastMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? character = null,Object? profilePath = freezed,}) {
  return _then(_CastMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
