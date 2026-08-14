// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_page_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoviePageResponseModel {

 int get page; List<MovieModel> get results;@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of MoviePageResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoviePageResponseModelCopyWith<MoviePageResponseModel> get copyWith => _$MoviePageResponseModelCopyWithImpl<MoviePageResponseModel>(this as MoviePageResponseModel, _$identity);

  /// Serializes this MoviePageResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoviePageResponseModel&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(results),totalPages);

@override
String toString() {
  return 'MoviePageResponseModel(page: $page, results: $results, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $MoviePageResponseModelCopyWith<$Res>  {
  factory $MoviePageResponseModelCopyWith(MoviePageResponseModel value, $Res Function(MoviePageResponseModel) _then) = _$MoviePageResponseModelCopyWithImpl;
@useResult
$Res call({
 int page, List<MovieModel> results,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$MoviePageResponseModelCopyWithImpl<$Res>
    implements $MoviePageResponseModelCopyWith<$Res> {
  _$MoviePageResponseModelCopyWithImpl(this._self, this._then);

  final MoviePageResponseModel _self;
  final $Res Function(MoviePageResponseModel) _then;

/// Create a copy of MoviePageResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? results = null,Object? totalPages = null,}) {
  return _then(MoviePageResponseModel(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MoviePageResponseModel].
extension MoviePageResponseModelPatterns on MoviePageResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoviePageResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoviePageResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoviePageResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _MoviePageResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoviePageResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _MoviePageResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  List<MovieModel> results, @JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoviePageResponseModel() when $default != null:
return $default(_that.page,_that.results,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  List<MovieModel> results, @JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _MoviePageResponseModel():
return $default(_that.page,_that.results,_that.totalPages);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  List<MovieModel> results, @JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _MoviePageResponseModel() when $default != null:
return $default(_that.page,_that.results,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoviePageResponseModel implements MoviePageResponseModel {
  const _MoviePageResponseModel({required this.page, required  List<MovieModel> results, @JsonKey(name: 'total_pages') required this.totalPages}): _results = results;
  factory _MoviePageResponseModel.fromJson(Map<String, dynamic> json) => _$MoviePageResponseModelFromJson(json);

@override final  int page;
 final  List<MovieModel> _results;
@override List<MovieModel> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of MoviePageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoviePageResponseModelCopyWith<_MoviePageResponseModel> get copyWith => __$MoviePageResponseModelCopyWithImpl<_MoviePageResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoviePageResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoviePageResponseModel&&(identical(other.page, page) || other.page == page)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,const DeepCollectionEquality().hash(_results),totalPages);

@override
String toString() {
  return 'MoviePageResponseModel(page: $page, results: $results, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$MoviePageResponseModelCopyWith<$Res> implements $MoviePageResponseModelCopyWith<$Res> {
  factory _$MoviePageResponseModelCopyWith(_MoviePageResponseModel value, $Res Function(_MoviePageResponseModel) _then) = __$MoviePageResponseModelCopyWithImpl;
@override @useResult
$Res call({
 int page, List<MovieModel> results,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$MoviePageResponseModelCopyWithImpl<$Res>
    implements _$MoviePageResponseModelCopyWith<$Res> {
  __$MoviePageResponseModelCopyWithImpl(this._self, this._then);

  final _MoviePageResponseModel _self;
  final $Res Function(_MoviePageResponseModel) _then;

/// Create a copy of MoviePageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? results = null,Object? totalPages = null,}) {
  return _then(_MoviePageResponseModel(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MovieModel>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
