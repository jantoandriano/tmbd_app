// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverState {

 List<Movie> get nowPlaying; List<Movie> get comingSoon;
/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverStateCopyWith<DiscoverState> get copyWith => _$DiscoverStateCopyWithImpl<DiscoverState>(this as DiscoverState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverState&&const DeepCollectionEquality().equals(other.nowPlaying, nowPlaying)&&const DeepCollectionEquality().equals(other.comingSoon, comingSoon));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(nowPlaying),const DeepCollectionEquality().hash(comingSoon));

@override
String toString() {
  return 'DiscoverState(nowPlaying: $nowPlaying, comingSoon: $comingSoon)';
}


}

/// @nodoc
abstract mixin class $DiscoverStateCopyWith<$Res>  {
  factory $DiscoverStateCopyWith(DiscoverState value, $Res Function(DiscoverState) _then) = _$DiscoverStateCopyWithImpl;
@useResult
$Res call({
 List<Movie> nowPlaying, List<Movie> comingSoon
});




}
/// @nodoc
class _$DiscoverStateCopyWithImpl<$Res>
    implements $DiscoverStateCopyWith<$Res> {
  _$DiscoverStateCopyWithImpl(this._self, this._then);

  final DiscoverState _self;
  final $Res Function(DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nowPlaying = null,Object? comingSoon = null,}) {
  return _then(DiscoverState(
nowPlaying: null == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as List<Movie>,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as List<Movie>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverState].
extension DiscoverStatePatterns on DiscoverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Movie> nowPlaying,  List<Movie> comingSoon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.nowPlaying,_that.comingSoon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Movie> nowPlaying,  List<Movie> comingSoon)  $default,) {final _that = this;
switch (_that) {
case _DiscoverState():
return $default(_that.nowPlaying,_that.comingSoon);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Movie> nowPlaying,  List<Movie> comingSoon)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.nowPlaying,_that.comingSoon);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverState implements DiscoverState {
  const _DiscoverState({ List<Movie> nowPlaying = const <Movie>[],  List<Movie> comingSoon = const <Movie>[]}): _nowPlaying = nowPlaying,_comingSoon = comingSoon;
  

 final  List<Movie> _nowPlaying;
@override@JsonKey() List<Movie> get nowPlaying {
  if (_nowPlaying is EqualUnmodifiableListView) return _nowPlaying;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nowPlaying);
}

 final  List<Movie> _comingSoon;
@override@JsonKey() List<Movie> get comingSoon {
  if (_comingSoon is EqualUnmodifiableListView) return _comingSoon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comingSoon);
}


/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverStateCopyWith<_DiscoverState> get copyWith => __$DiscoverStateCopyWithImpl<_DiscoverState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverState&&const DeepCollectionEquality().equals(other._nowPlaying, _nowPlaying)&&const DeepCollectionEquality().equals(other._comingSoon, _comingSoon));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_nowPlaying),const DeepCollectionEquality().hash(_comingSoon));

@override
String toString() {
  return 'DiscoverState(nowPlaying: $nowPlaying, comingSoon: $comingSoon)';
}


}

/// @nodoc
abstract mixin class _$DiscoverStateCopyWith<$Res> implements $DiscoverStateCopyWith<$Res> {
  factory _$DiscoverStateCopyWith(_DiscoverState value, $Res Function(_DiscoverState) _then) = __$DiscoverStateCopyWithImpl;
@override @useResult
$Res call({
 List<Movie> nowPlaying, List<Movie> comingSoon
});




}
/// @nodoc
class __$DiscoverStateCopyWithImpl<$Res>
    implements _$DiscoverStateCopyWith<$Res> {
  __$DiscoverStateCopyWithImpl(this._self, this._then);

  final _DiscoverState _self;
  final $Res Function(_DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nowPlaying = null,Object? comingSoon = null,}) {
  return _then(_DiscoverState(
nowPlaying: null == nowPlaying ? _self._nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as List<Movie>,comingSoon: null == comingSoon ? _self._comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as List<Movie>,
  ));
}


}

// dart format on
