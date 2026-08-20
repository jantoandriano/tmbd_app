// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genre_list_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenreListResponseModel {

 List<GenreModel> get genres;
/// Create a copy of GenreListResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreListResponseModelCopyWith<GenreListResponseModel> get copyWith => _$GenreListResponseModelCopyWithImpl<GenreListResponseModel>(this as GenreListResponseModel, _$identity);

  /// Serializes this GenreListResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreListResponseModel&&const DeepCollectionEquality().equals(other.genres, genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'GenreListResponseModel(genres: $genres)';
}


}

/// @nodoc
abstract mixin class $GenreListResponseModelCopyWith<$Res>  {
  factory $GenreListResponseModelCopyWith(GenreListResponseModel value, $Res Function(GenreListResponseModel) _then) = _$GenreListResponseModelCopyWithImpl;
@useResult
$Res call({
 List<GenreModel> genres
});




}
/// @nodoc
class _$GenreListResponseModelCopyWithImpl<$Res>
    implements $GenreListResponseModelCopyWith<$Res> {
  _$GenreListResponseModelCopyWithImpl(this._self, this._then);

  final GenreListResponseModel _self;
  final $Res Function(GenreListResponseModel) _then;

/// Create a copy of GenreListResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genres = null,}) {
  return _then(GenreListResponseModel(
genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenreListResponseModel].
extension GenreListResponseModelPatterns on GenreListResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenreListResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenreListResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenreListResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _GenreListResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenreListResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _GenreListResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GenreModel> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenreListResponseModel() when $default != null:
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GenreModel> genres)  $default,) {final _that = this;
switch (_that) {
case _GenreListResponseModel():
return $default(_that.genres);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GenreModel> genres)?  $default,) {final _that = this;
switch (_that) {
case _GenreListResponseModel() when $default != null:
return $default(_that.genres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenreListResponseModel implements GenreListResponseModel {
  const _GenreListResponseModel({required  List<GenreModel> genres}): _genres = genres;
  factory _GenreListResponseModel.fromJson(Map<String, dynamic> json) => _$GenreListResponseModelFromJson(json);

 final  List<GenreModel> _genres;
@override List<GenreModel> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of GenreListResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreListResponseModelCopyWith<_GenreListResponseModel> get copyWith => __$GenreListResponseModelCopyWithImpl<_GenreListResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreListResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreListResponseModel&&const DeepCollectionEquality().equals(other._genres, _genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'GenreListResponseModel(genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$GenreListResponseModelCopyWith<$Res> implements $GenreListResponseModelCopyWith<$Res> {
  factory _$GenreListResponseModelCopyWith(_GenreListResponseModel value, $Res Function(_GenreListResponseModel) _then) = __$GenreListResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<GenreModel> genres
});




}
/// @nodoc
class __$GenreListResponseModelCopyWithImpl<$Res>
    implements _$GenreListResponseModelCopyWith<$Res> {
  __$GenreListResponseModelCopyWithImpl(this._self, this._then);

  final _GenreListResponseModel _self;
  final $Res Function(_GenreListResponseModel) _then;

/// Create a copy of GenreListResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genres = null,}) {
  return _then(_GenreListResponseModel(
genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,
  ));
}


}

// dart format on
