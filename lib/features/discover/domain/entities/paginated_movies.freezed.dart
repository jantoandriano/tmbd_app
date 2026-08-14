// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_movies.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedMovies {

 List<Movie> get movies; int get page; int get totalPages;
/// Create a copy of PaginatedMovies
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedMoviesCopyWith<PaginatedMovies> get copyWith => _$PaginatedMoviesCopyWithImpl<PaginatedMovies>(this as PaginatedMovies, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedMovies&&const DeepCollectionEquality().equals(other.movies, movies)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(movies),page,totalPages);

@override
String toString() {
  return 'PaginatedMovies(movies: $movies, page: $page, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $PaginatedMoviesCopyWith<$Res>  {
  factory $PaginatedMoviesCopyWith(PaginatedMovies value, $Res Function(PaginatedMovies) _then) = _$PaginatedMoviesCopyWithImpl;
@useResult
$Res call({
 List<Movie> movies, int page, int totalPages
});




}
/// @nodoc
class _$PaginatedMoviesCopyWithImpl<$Res>
    implements $PaginatedMoviesCopyWith<$Res> {
  _$PaginatedMoviesCopyWithImpl(this._self, this._then);

  final PaginatedMovies _self;
  final $Res Function(PaginatedMovies) _then;

/// Create a copy of PaginatedMovies
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movies = null,Object? page = null,Object? totalPages = null,}) {
  return _then(PaginatedMovies(
movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedMovies].
extension PaginatedMoviesPatterns on PaginatedMovies {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedMovies value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedMovies() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedMovies value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedMovies():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedMovies value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedMovies() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Movie> movies,  int page,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedMovies() when $default != null:
return $default(_that.movies,_that.page,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Movie> movies,  int page,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _PaginatedMovies():
return $default(_that.movies,_that.page,_that.totalPages);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Movie> movies,  int page,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedMovies() when $default != null:
return $default(_that.movies,_that.page,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class _PaginatedMovies implements PaginatedMovies {
  const _PaginatedMovies({required  List<Movie> movies, required this.page, required this.totalPages}): _movies = movies;
  

 final  List<Movie> _movies;
@override List<Movie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

@override final  int page;
@override final  int totalPages;

/// Create a copy of PaginatedMovies
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedMoviesCopyWith<_PaginatedMovies> get copyWith => __$PaginatedMoviesCopyWithImpl<_PaginatedMovies>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedMovies&&const DeepCollectionEquality().equals(other._movies, _movies)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_movies),page,totalPages);

@override
String toString() {
  return 'PaginatedMovies(movies: $movies, page: $page, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$PaginatedMoviesCopyWith<$Res> implements $PaginatedMoviesCopyWith<$Res> {
  factory _$PaginatedMoviesCopyWith(_PaginatedMovies value, $Res Function(_PaginatedMovies) _then) = __$PaginatedMoviesCopyWithImpl;
@override @useResult
$Res call({
 List<Movie> movies, int page, int totalPages
});




}
/// @nodoc
class __$PaginatedMoviesCopyWithImpl<$Res>
    implements _$PaginatedMoviesCopyWith<$Res> {
  __$PaginatedMoviesCopyWithImpl(this._self, this._then);

  final _PaginatedMovies _self;
  final $Res Function(_PaginatedMovies) _then;

/// Create a copy of PaginatedMovies
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movies = null,Object? page = null,Object? totalPages = null,}) {
  return _then(_PaginatedMovies(
movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
