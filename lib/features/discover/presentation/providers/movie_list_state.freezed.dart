// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieListState {

 List<Movie> get movies; int get page; int get totalPages; bool get isLoadingMore;
/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListStateCopyWith<MovieListState> get copyWith => _$MovieListStateCopyWithImpl<MovieListState>(this as MovieListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListState&&const DeepCollectionEquality().equals(other.movies, movies)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(movies),page,totalPages,isLoadingMore);

@override
String toString() {
  return 'MovieListState(movies: $movies, page: $page, totalPages: $totalPages, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $MovieListStateCopyWith<$Res>  {
  factory $MovieListStateCopyWith(MovieListState value, $Res Function(MovieListState) _then) = _$MovieListStateCopyWithImpl;
@useResult
$Res call({
 List<Movie> movies, int page, int totalPages, bool isLoadingMore
});




}
/// @nodoc
class _$MovieListStateCopyWithImpl<$Res>
    implements $MovieListStateCopyWith<$Res> {
  _$MovieListStateCopyWithImpl(this._self, this._then);

  final MovieListState _self;
  final $Res Function(MovieListState) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movies = null,Object? page = null,Object? totalPages = null,Object? isLoadingMore = null,}) {
  return _then(MovieListState(
movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieListState].
extension MovieListStatePatterns on MovieListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieListState value)  $default,){
final _that = this;
switch (_that) {
case _MovieListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieListState value)?  $default,){
final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Movie> movies,  int page,  int totalPages,  bool isLoadingMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
return $default(_that.movies,_that.page,_that.totalPages,_that.isLoadingMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Movie> movies,  int page,  int totalPages,  bool isLoadingMore)  $default,) {final _that = this;
switch (_that) {
case _MovieListState():
return $default(_that.movies,_that.page,_that.totalPages,_that.isLoadingMore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Movie> movies,  int page,  int totalPages,  bool isLoadingMore)?  $default,) {final _that = this;
switch (_that) {
case _MovieListState() when $default != null:
return $default(_that.movies,_that.page,_that.totalPages,_that.isLoadingMore);case _:
  return null;

}
}

}

/// @nodoc


class _MovieListState implements MovieListState {
  const _MovieListState({ List<Movie> movies = const <Movie>[], this.page = 1, this.totalPages = 1, this.isLoadingMore = false}): _movies = movies;
  

 final  List<Movie> _movies;
@override@JsonKey() List<Movie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  bool isLoadingMore;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieListStateCopyWith<_MovieListState> get copyWith => __$MovieListStateCopyWithImpl<_MovieListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieListState&&const DeepCollectionEquality().equals(other._movies, _movies)&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_movies),page,totalPages,isLoadingMore);

@override
String toString() {
  return 'MovieListState(movies: $movies, page: $page, totalPages: $totalPages, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class _$MovieListStateCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory _$MovieListStateCopyWith(_MovieListState value, $Res Function(_MovieListState) _then) = __$MovieListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Movie> movies, int page, int totalPages, bool isLoadingMore
});




}
/// @nodoc
class __$MovieListStateCopyWithImpl<$Res>
    implements _$MovieListStateCopyWith<$Res> {
  __$MovieListStateCopyWithImpl(this._self, this._then);

  final _MovieListState _self;
  final $Res Function(_MovieListState) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movies = null,Object? page = null,Object? totalPages = null,Object? isLoadingMore = null,}) {
  return _then(_MovieListState(
movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
