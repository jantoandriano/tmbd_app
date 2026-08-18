// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenreModel {

 int get id; String get name;
/// Create a copy of GenreModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreModelCopyWith<GenreModel> get copyWith => _$GenreModelCopyWithImpl<GenreModel>(this as GenreModel, _$identity);

  /// Serializes this GenreModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'GenreModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $GenreModelCopyWith<$Res>  {
  factory $GenreModelCopyWith(GenreModel value, $Res Function(GenreModel) _then) = _$GenreModelCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$GenreModelCopyWithImpl<$Res>
    implements $GenreModelCopyWith<$Res> {
  _$GenreModelCopyWithImpl(this._self, this._then);

  final GenreModel _self;
  final $Res Function(GenreModel) _then;

/// Create a copy of GenreModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(GenreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GenreModel].
extension GenreModelPatterns on GenreModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenreModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenreModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenreModel value)  $default,){
final _that = this;
switch (_that) {
case _GenreModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenreModel value)?  $default,){
final _that = this;
switch (_that) {
case _GenreModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenreModel() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _GenreModel():
return $default(_that.id,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _GenreModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenreModel implements GenreModel {
  const _GenreModel({required this.id, required this.name});
  factory _GenreModel.fromJson(Map<String, dynamic> json) => _$GenreModelFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of GenreModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreModelCopyWith<_GenreModel> get copyWith => __$GenreModelCopyWithImpl<_GenreModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'GenreModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$GenreModelCopyWith<$Res> implements $GenreModelCopyWith<$Res> {
  factory _$GenreModelCopyWith(_GenreModel value, $Res Function(_GenreModel) _then) = __$GenreModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$GenreModelCopyWithImpl<$Res>
    implements _$GenreModelCopyWith<$Res> {
  __$GenreModelCopyWithImpl(this._self, this._then);

  final _GenreModel _self;
  final $Res Function(_GenreModel) _then;

/// Create a copy of GenreModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_GenreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CastMemberModel {

 int get id; String get name; String get character; int get order;@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of CastMemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CastMemberModelCopyWith<CastMemberModel> get copyWith => _$CastMemberModelCopyWithImpl<CastMemberModel>(this as CastMemberModel, _$identity);

  /// Serializes this CastMemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CastMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.character, character) || other.character == character)&&(identical(other.order, order) || other.order == order)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,character,order,profilePath);

@override
String toString() {
  return 'CastMemberModel(id: $id, name: $name, character: $character, order: $order, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $CastMemberModelCopyWith<$Res>  {
  factory $CastMemberModelCopyWith(CastMemberModel value, $Res Function(CastMemberModel) _then) = _$CastMemberModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String character, int order,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$CastMemberModelCopyWithImpl<$Res>
    implements $CastMemberModelCopyWith<$Res> {
  _$CastMemberModelCopyWithImpl(this._self, this._then);

  final CastMemberModel _self;
  final $Res Function(CastMemberModel) _then;

/// Create a copy of CastMemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? character = null,Object? order = null,Object? profilePath = freezed,}) {
  return _then(CastMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CastMemberModel].
extension CastMemberModelPatterns on CastMemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CastMemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CastMemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CastMemberModel value)  $default,){
final _that = this;
switch (_that) {
case _CastMemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CastMemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _CastMemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String character,  int order, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CastMemberModel() when $default != null:
return $default(_that.id,_that.name,_that.character,_that.order,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String character,  int order, @JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _CastMemberModel():
return $default(_that.id,_that.name,_that.character,_that.order,_that.profilePath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String character,  int order, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _CastMemberModel() when $default != null:
return $default(_that.id,_that.name,_that.character,_that.order,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CastMemberModel implements CastMemberModel {
  const _CastMemberModel({required this.id, required this.name, required this.character, required this.order, @JsonKey(name: 'profile_path') this.profilePath});
  factory _CastMemberModel.fromJson(Map<String, dynamic> json) => _$CastMemberModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String character;
@override final  int order;
@override@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of CastMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CastMemberModelCopyWith<_CastMemberModel> get copyWith => __$CastMemberModelCopyWithImpl<_CastMemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CastMemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CastMemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.character, character) || other.character == character)&&(identical(other.order, order) || other.order == order)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,character,order,profilePath);

@override
String toString() {
  return 'CastMemberModel(id: $id, name: $name, character: $character, order: $order, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$CastMemberModelCopyWith<$Res> implements $CastMemberModelCopyWith<$Res> {
  factory _$CastMemberModelCopyWith(_CastMemberModel value, $Res Function(_CastMemberModel) _then) = __$CastMemberModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String character, int order,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$CastMemberModelCopyWithImpl<$Res>
    implements _$CastMemberModelCopyWith<$Res> {
  __$CastMemberModelCopyWithImpl(this._self, this._then);

  final _CastMemberModel _self;
  final $Res Function(_CastMemberModel) _then;

/// Create a copy of CastMemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? character = null,Object? order = null,Object? profilePath = freezed,}) {
  return _then(_CastMemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreditsModel {

 List<CastMemberModel> get cast;
/// Create a copy of CreditsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditsModelCopyWith<CreditsModel> get copyWith => _$CreditsModelCopyWithImpl<CreditsModel>(this as CreditsModel, _$identity);

  /// Serializes this CreditsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditsModel&&const DeepCollectionEquality().equals(other.cast, cast));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cast));

@override
String toString() {
  return 'CreditsModel(cast: $cast)';
}


}

/// @nodoc
abstract mixin class $CreditsModelCopyWith<$Res>  {
  factory $CreditsModelCopyWith(CreditsModel value, $Res Function(CreditsModel) _then) = _$CreditsModelCopyWithImpl;
@useResult
$Res call({
 List<CastMemberModel> cast
});




}
/// @nodoc
class _$CreditsModelCopyWithImpl<$Res>
    implements $CreditsModelCopyWith<$Res> {
  _$CreditsModelCopyWithImpl(this._self, this._then);

  final CreditsModel _self;
  final $Res Function(CreditsModel) _then;

/// Create a copy of CreditsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cast = null,}) {
  return _then(CreditsModel(
cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMemberModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditsModel].
extension CreditsModelPatterns on CreditsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditsModel value)  $default,){
final _that = this;
switch (_that) {
case _CreditsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditsModel value)?  $default,){
final _that = this;
switch (_that) {
case _CreditsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CastMemberModel> cast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditsModel() when $default != null:
return $default(_that.cast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CastMemberModel> cast)  $default,) {final _that = this;
switch (_that) {
case _CreditsModel():
return $default(_that.cast);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CastMemberModel> cast)?  $default,) {final _that = this;
switch (_that) {
case _CreditsModel() when $default != null:
return $default(_that.cast);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditsModel implements CreditsModel {
  const _CreditsModel({ List<CastMemberModel> cast = const <CastMemberModel>[]}): _cast = cast;
  factory _CreditsModel.fromJson(Map<String, dynamic> json) => _$CreditsModelFromJson(json);

 final  List<CastMemberModel> _cast;
@override@JsonKey() List<CastMemberModel> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}


/// Create a copy of CreditsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditsModelCopyWith<_CreditsModel> get copyWith => __$CreditsModelCopyWithImpl<_CreditsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditsModel&&const DeepCollectionEquality().equals(other._cast, _cast));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cast));

@override
String toString() {
  return 'CreditsModel(cast: $cast)';
}


}

/// @nodoc
abstract mixin class _$CreditsModelCopyWith<$Res> implements $CreditsModelCopyWith<$Res> {
  factory _$CreditsModelCopyWith(_CreditsModel value, $Res Function(_CreditsModel) _then) = __$CreditsModelCopyWithImpl;
@override @useResult
$Res call({
 List<CastMemberModel> cast
});




}
/// @nodoc
class __$CreditsModelCopyWithImpl<$Res>
    implements _$CreditsModelCopyWith<$Res> {
  __$CreditsModelCopyWithImpl(this._self, this._then);

  final _CreditsModel _self;
  final $Res Function(_CreditsModel) _then;

/// Create a copy of CreditsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cast = null,}) {
  return _then(_CreditsModel(
cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMemberModel>,
  ));
}


}


/// @nodoc
mixin _$VideoModel {

 String get key; String get site; String get type; bool get official;
/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoModelCopyWith<VideoModel> get copyWith => _$VideoModelCopyWithImpl<VideoModel>(this as VideoModel, _$identity);

  /// Serializes this VideoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoModel&&(identical(other.key, key) || other.key == key)&&(identical(other.site, site) || other.site == site)&&(identical(other.type, type) || other.type == type)&&(identical(other.official, official) || other.official == official));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,site,type,official);

@override
String toString() {
  return 'VideoModel(key: $key, site: $site, type: $type, official: $official)';
}


}

/// @nodoc
abstract mixin class $VideoModelCopyWith<$Res>  {
  factory $VideoModelCopyWith(VideoModel value, $Res Function(VideoModel) _then) = _$VideoModelCopyWithImpl;
@useResult
$Res call({
 String key, String site, String type, bool official
});




}
/// @nodoc
class _$VideoModelCopyWithImpl<$Res>
    implements $VideoModelCopyWith<$Res> {
  _$VideoModelCopyWithImpl(this._self, this._then);

  final VideoModel _self;
  final $Res Function(VideoModel) _then;

/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? site = null,Object? type = null,Object? official = null,}) {
  return _then(VideoModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,official: null == official ? _self.official : official // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoModel].
extension VideoModelPatterns on VideoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoModel value)  $default,){
final _that = this;
switch (_that) {
case _VideoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String site,  String type,  bool official)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
return $default(_that.key,_that.site,_that.type,_that.official);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String site,  String type,  bool official)  $default,) {final _that = this;
switch (_that) {
case _VideoModel():
return $default(_that.key,_that.site,_that.type,_that.official);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String site,  String type,  bool official)?  $default,) {final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
return $default(_that.key,_that.site,_that.type,_that.official);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoModel implements VideoModel {
  const _VideoModel({required this.key, required this.site, required this.type, this.official = false});
  factory _VideoModel.fromJson(Map<String, dynamic> json) => _$VideoModelFromJson(json);

@override final  String key;
@override final  String site;
@override final  String type;
@override@JsonKey() final  bool official;

/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoModelCopyWith<_VideoModel> get copyWith => __$VideoModelCopyWithImpl<_VideoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoModel&&(identical(other.key, key) || other.key == key)&&(identical(other.site, site) || other.site == site)&&(identical(other.type, type) || other.type == type)&&(identical(other.official, official) || other.official == official));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,site,type,official);

@override
String toString() {
  return 'VideoModel(key: $key, site: $site, type: $type, official: $official)';
}


}

/// @nodoc
abstract mixin class _$VideoModelCopyWith<$Res> implements $VideoModelCopyWith<$Res> {
  factory _$VideoModelCopyWith(_VideoModel value, $Res Function(_VideoModel) _then) = __$VideoModelCopyWithImpl;
@override @useResult
$Res call({
 String key, String site, String type, bool official
});




}
/// @nodoc
class __$VideoModelCopyWithImpl<$Res>
    implements _$VideoModelCopyWith<$Res> {
  __$VideoModelCopyWithImpl(this._self, this._then);

  final _VideoModel _self;
  final $Res Function(_VideoModel) _then;

/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? site = null,Object? type = null,Object? official = null,}) {
  return _then(_VideoModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,official: null == official ? _self.official : official // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$VideosResponseModel {

 List<VideoModel> get results;
/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideosResponseModelCopyWith<VideosResponseModel> get copyWith => _$VideosResponseModelCopyWithImpl<VideosResponseModel>(this as VideosResponseModel, _$identity);

  /// Serializes this VideosResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideosResponseModel&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'VideosResponseModel(results: $results)';
}


}

/// @nodoc
abstract mixin class $VideosResponseModelCopyWith<$Res>  {
  factory $VideosResponseModelCopyWith(VideosResponseModel value, $Res Function(VideosResponseModel) _then) = _$VideosResponseModelCopyWithImpl;
@useResult
$Res call({
 List<VideoModel> results
});




}
/// @nodoc
class _$VideosResponseModelCopyWithImpl<$Res>
    implements $VideosResponseModelCopyWith<$Res> {
  _$VideosResponseModelCopyWithImpl(this._self, this._then);

  final VideosResponseModel _self;
  final $Res Function(VideosResponseModel) _then;

/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(VideosResponseModel(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [VideosResponseModel].
extension VideosResponseModelPatterns on VideosResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideosResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideosResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _VideosResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideosResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VideoModel> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VideoModel> results)  $default,) {final _that = this;
switch (_that) {
case _VideosResponseModel():
return $default(_that.results);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VideoModel> results)?  $default,) {final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideosResponseModel implements VideosResponseModel {
  const _VideosResponseModel({ List<VideoModel> results = const <VideoModel>[]}): _results = results;
  factory _VideosResponseModel.fromJson(Map<String, dynamic> json) => _$VideosResponseModelFromJson(json);

 final  List<VideoModel> _results;
@override@JsonKey() List<VideoModel> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideosResponseModelCopyWith<_VideosResponseModel> get copyWith => __$VideosResponseModelCopyWithImpl<_VideosResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideosResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideosResponseModel&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'VideosResponseModel(results: $results)';
}


}

/// @nodoc
abstract mixin class _$VideosResponseModelCopyWith<$Res> implements $VideosResponseModelCopyWith<$Res> {
  factory _$VideosResponseModelCopyWith(_VideosResponseModel value, $Res Function(_VideosResponseModel) _then) = __$VideosResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<VideoModel> results
});




}
/// @nodoc
class __$VideosResponseModelCopyWithImpl<$Res>
    implements _$VideosResponseModelCopyWith<$Res> {
  __$VideosResponseModelCopyWithImpl(this._self, this._then);

  final _VideosResponseModel _self;
  final $Res Function(_VideosResponseModel) _then;

/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_VideosResponseModel(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,
  ));
}


}


/// @nodoc
mixin _$MovieDetailsModel {

 int get id; String get title; String get overview;@JsonKey(name: 'vote_average') double get voteAverage;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'backdrop_path') String? get backdropPath;@JsonKey(name: 'release_date') String? get releaseDate; int? get runtime; List<GenreModel> get genres; CreditsModel? get credits; VideosResponseModel? get videos;
/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailsModelCopyWith<MovieDetailsModel> get copyWith => _$MovieDetailsModelCopyWithImpl<MovieDetailsModel>(this as MovieDetailsModel, _$identity);

  /// Serializes this MovieDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.videos, videos) || other.videos == videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,overview,voteAverage,posterPath,backdropPath,releaseDate,runtime,const DeepCollectionEquality().hash(genres),credits,videos);

@override
String toString() {
  return 'MovieDetailsModel(id: $id, title: $title, overview: $overview, voteAverage: $voteAverage, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, runtime: $runtime, genres: $genres, credits: $credits, videos: $videos)';
}


}

/// @nodoc
abstract mixin class $MovieDetailsModelCopyWith<$Res>  {
  factory $MovieDetailsModelCopyWith(MovieDetailsModel value, $Res Function(MovieDetailsModel) _then) = _$MovieDetailsModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String overview,@JsonKey(name: 'vote_average') double voteAverage,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'backdrop_path') String? backdropPath,@JsonKey(name: 'release_date') String? releaseDate, int? runtime, List<GenreModel> genres, CreditsModel? credits, VideosResponseModel? videos
});


$CreditsModelCopyWith<$Res>? get credits;$VideosResponseModelCopyWith<$Res>? get videos;

}
/// @nodoc
class _$MovieDetailsModelCopyWithImpl<$Res>
    implements $MovieDetailsModelCopyWith<$Res> {
  _$MovieDetailsModelCopyWithImpl(this._self, this._then);

  final MovieDetailsModel _self;
  final $Res Function(MovieDetailsModel) _then;

/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? overview = null,Object? voteAverage = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,Object? runtime = freezed,Object? genres = null,Object? credits = freezed,Object? videos = freezed,}) {
  return _then(MovieDetailsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,credits: freezed == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as CreditsModel?,videos: freezed == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as VideosResponseModel?,
  ));
}
/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreditsModelCopyWith<$Res>? get credits {
    if (_self.credits == null) {
    return null;
  }

  return $CreditsModelCopyWith<$Res>(_self.credits!, (value) {
    return _then(_self.copyWith(credits: value));
  });
}/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideosResponseModelCopyWith<$Res>? get videos {
    if (_self.videos == null) {
    return null;
  }

  return $VideosResponseModelCopyWith<$Res>(_self.videos!, (value) {
    return _then(_self.copyWith(videos: value));
  });
}
}


/// Adds pattern-matching-related methods to [MovieDetailsModel].
extension MovieDetailsModelPatterns on MovieDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _MovieDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _MovieDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String overview, @JsonKey(name: 'vote_average')  double voteAverage, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'backdrop_path')  String? backdropPath, @JsonKey(name: 'release_date')  String? releaseDate,  int? runtime,  List<GenreModel> genres,  CreditsModel? credits,  VideosResponseModel? videos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieDetailsModel() when $default != null:
return $default(_that.id,_that.title,_that.overview,_that.voteAverage,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtime,_that.genres,_that.credits,_that.videos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String overview, @JsonKey(name: 'vote_average')  double voteAverage, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'backdrop_path')  String? backdropPath, @JsonKey(name: 'release_date')  String? releaseDate,  int? runtime,  List<GenreModel> genres,  CreditsModel? credits,  VideosResponseModel? videos)  $default,) {final _that = this;
switch (_that) {
case _MovieDetailsModel():
return $default(_that.id,_that.title,_that.overview,_that.voteAverage,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtime,_that.genres,_that.credits,_that.videos);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String overview, @JsonKey(name: 'vote_average')  double voteAverage, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'backdrop_path')  String? backdropPath, @JsonKey(name: 'release_date')  String? releaseDate,  int? runtime,  List<GenreModel> genres,  CreditsModel? credits,  VideosResponseModel? videos)?  $default,) {final _that = this;
switch (_that) {
case _MovieDetailsModel() when $default != null:
return $default(_that.id,_that.title,_that.overview,_that.voteAverage,_that.posterPath,_that.backdropPath,_that.releaseDate,_that.runtime,_that.genres,_that.credits,_that.videos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovieDetailsModel extends MovieDetailsModel {
  const _MovieDetailsModel({required this.id, required this.title, required this.overview, @JsonKey(name: 'vote_average') required this.voteAverage, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'backdrop_path') this.backdropPath, @JsonKey(name: 'release_date') this.releaseDate, this.runtime,  List<GenreModel> genres = const <GenreModel>[], this.credits, this.videos}): _genres = genres,super._();
  factory _MovieDetailsModel.fromJson(Map<String, dynamic> json) => _$MovieDetailsModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String overview;
@override@JsonKey(name: 'vote_average') final  double voteAverage;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@JsonKey(name: 'release_date') final  String? releaseDate;
@override final  int? runtime;
 final  List<GenreModel> _genres;
@override@JsonKey() List<GenreModel> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override final  CreditsModel? credits;
@override final  VideosResponseModel? videos;

/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieDetailsModelCopyWith<_MovieDetailsModel> get copyWith => __$MovieDetailsModelCopyWithImpl<_MovieDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieDetailsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.runtime, runtime) || other.runtime == runtime)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.videos, videos) || other.videos == videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,overview,voteAverage,posterPath,backdropPath,releaseDate,runtime,const DeepCollectionEquality().hash(_genres),credits,videos);

@override
String toString() {
  return 'MovieDetailsModel(id: $id, title: $title, overview: $overview, voteAverage: $voteAverage, posterPath: $posterPath, backdropPath: $backdropPath, releaseDate: $releaseDate, runtime: $runtime, genres: $genres, credits: $credits, videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$MovieDetailsModelCopyWith<$Res> implements $MovieDetailsModelCopyWith<$Res> {
  factory _$MovieDetailsModelCopyWith(_MovieDetailsModel value, $Res Function(_MovieDetailsModel) _then) = __$MovieDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String overview,@JsonKey(name: 'vote_average') double voteAverage,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'backdrop_path') String? backdropPath,@JsonKey(name: 'release_date') String? releaseDate, int? runtime, List<GenreModel> genres, CreditsModel? credits, VideosResponseModel? videos
});


@override $CreditsModelCopyWith<$Res>? get credits;@override $VideosResponseModelCopyWith<$Res>? get videos;

}
/// @nodoc
class __$MovieDetailsModelCopyWithImpl<$Res>
    implements _$MovieDetailsModelCopyWith<$Res> {
  __$MovieDetailsModelCopyWithImpl(this._self, this._then);

  final _MovieDetailsModel _self;
  final $Res Function(_MovieDetailsModel) _then;

/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? overview = null,Object? voteAverage = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? releaseDate = freezed,Object? runtime = freezed,Object? genres = null,Object? credits = freezed,Object? videos = freezed,}) {
  return _then(_MovieDetailsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreModel>,credits: freezed == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as CreditsModel?,videos: freezed == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as VideosResponseModel?,
  ));
}

/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreditsModelCopyWith<$Res>? get credits {
    if (_self.credits == null) {
    return null;
  }

  return $CreditsModelCopyWith<$Res>(_self.credits!, (value) {
    return _then(_self.copyWith(credits: value));
  });
}/// Create a copy of MovieDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideosResponseModelCopyWith<$Res>? get videos {
    if (_self.videos == null) {
    return null;
  }

  return $VideosResponseModelCopyWith<$Res>(_self.videos!, (value) {
    return _then(_self.copyWith(videos: value));
  });
}
}

// dart format on
