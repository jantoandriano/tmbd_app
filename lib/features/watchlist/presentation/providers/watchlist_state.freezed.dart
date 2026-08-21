// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchlistState {

 List<Movie> get movies;
/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistStateCopyWith<WatchlistState> get copyWith => _$WatchlistStateCopyWithImpl<WatchlistState>(this as WatchlistState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistState&&const DeepCollectionEquality().equals(other.movies, movies));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(movies));

@override
String toString() {
  return 'WatchlistState(movies: $movies)';
}


}

/// @nodoc
abstract mixin class $WatchlistStateCopyWith<$Res>  {
  factory $WatchlistStateCopyWith(WatchlistState value, $Res Function(WatchlistState) _then) = _$WatchlistStateCopyWithImpl;
@useResult
$Res call({
 List<Movie> movies
});




}
/// @nodoc
class _$WatchlistStateCopyWithImpl<$Res>
    implements $WatchlistStateCopyWith<$Res> {
  _$WatchlistStateCopyWithImpl(this._self, this._then);

  final WatchlistState _self;
  final $Res Function(WatchlistState) _then;

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movies = null,}) {
  return _then(WatchlistState(
movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchlistState].
extension WatchlistStatePatterns on WatchlistState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistState value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistState value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Movie> movies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistState() when $default != null:
return $default(_that.movies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Movie> movies)  $default,) {final _that = this;
switch (_that) {
case _WatchlistState():
return $default(_that.movies);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Movie> movies)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistState() when $default != null:
return $default(_that.movies);case _:
  return null;

}
}

}

/// @nodoc


class _WatchlistState implements WatchlistState {
  const _WatchlistState({ List<Movie> movies = const <Movie>[]}): _movies = movies;
  

 final  List<Movie> _movies;
@override@JsonKey() List<Movie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}


/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistStateCopyWith<_WatchlistState> get copyWith => __$WatchlistStateCopyWithImpl<_WatchlistState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistState&&const DeepCollectionEquality().equals(other._movies, _movies));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_movies));

@override
String toString() {
  return 'WatchlistState(movies: $movies)';
}


}

/// @nodoc
abstract mixin class _$WatchlistStateCopyWith<$Res> implements $WatchlistStateCopyWith<$Res> {
  factory _$WatchlistStateCopyWith(_WatchlistState value, $Res Function(_WatchlistState) _then) = __$WatchlistStateCopyWithImpl;
@override @useResult
$Res call({
 List<Movie> movies
});




}
/// @nodoc
class __$WatchlistStateCopyWithImpl<$Res>
    implements _$WatchlistStateCopyWith<$Res> {
  __$WatchlistStateCopyWithImpl(this._self, this._then);

  final _WatchlistState _self;
  final $Res Function(_WatchlistState) _then;

/// Create a copy of WatchlistState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movies = null,}) {
  return _then(_WatchlistState(
movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,
  ));
}


}

// dart format on
