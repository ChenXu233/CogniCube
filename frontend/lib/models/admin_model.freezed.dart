// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserInfo {

 int get id; String get username; String get email; bool get is_admin; bool get is_verified;
/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInfoCopyWith<UserInfo> get copyWith => _$UserInfoCopyWithImpl<UserInfo>(this as UserInfo, _$identity);

  /// Serializes this UserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.is_admin, is_admin) || other.is_admin == is_admin)&&(identical(other.is_verified, is_verified) || other.is_verified == is_verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,is_admin,is_verified);

@override
String toString() {
  return 'UserInfo(id: $id, username: $username, email: $email, is_admin: $is_admin, is_verified: $is_verified)';
}


}

/// @nodoc
abstract mixin class $UserInfoCopyWith<$Res>  {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) _then) = _$UserInfoCopyWithImpl;
@useResult
$Res call({
 int id, String username, String email, bool is_admin, bool is_verified
});




}
/// @nodoc
class _$UserInfoCopyWithImpl<$Res>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._self, this._then);

  final UserInfo _self;
  final $Res Function(UserInfo) _then;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? is_admin = null,Object? is_verified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,is_admin: null == is_admin ? _self.is_admin : is_admin // ignore: cast_nullable_to_non_nullable
as bool,is_verified: null == is_verified ? _self.is_verified : is_verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserInfo implements UserInfo {
  const _UserInfo({required this.id, required this.username, required this.email, required this.is_admin, required this.is_verified});
  factory _UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

@override final  int id;
@override final  String username;
@override final  String email;
@override final  bool is_admin;
@override final  bool is_verified;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInfoCopyWith<_UserInfo> get copyWith => __$UserInfoCopyWithImpl<_UserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.is_admin, is_admin) || other.is_admin == is_admin)&&(identical(other.is_verified, is_verified) || other.is_verified == is_verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,is_admin,is_verified);

@override
String toString() {
  return 'UserInfo(id: $id, username: $username, email: $email, is_admin: $is_admin, is_verified: $is_verified)';
}


}

/// @nodoc
abstract mixin class _$UserInfoCopyWith<$Res> implements $UserInfoCopyWith<$Res> {
  factory _$UserInfoCopyWith(_UserInfo value, $Res Function(_UserInfo) _then) = __$UserInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String email, bool is_admin, bool is_verified
});




}
/// @nodoc
class __$UserInfoCopyWithImpl<$Res>
    implements _$UserInfoCopyWith<$Res> {
  __$UserInfoCopyWithImpl(this._self, this._then);

  final _UserInfo _self;
  final $Res Function(_UserInfo) _then;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? is_admin = null,Object? is_verified = null,}) {
  return _then(_UserInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,is_admin: null == is_admin ? _self.is_admin : is_admin // ignore: cast_nullable_to_non_nullable
as bool,is_verified: null == is_verified ? _self.is_verified : is_verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UserCreate {

 String get username; String get email; String get password; bool get is_admin;
/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCreateCopyWith<UserCreate> get copyWith => _$UserCreateCopyWithImpl<UserCreate>(this as UserCreate, _$identity);

  /// Serializes this UserCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserCreate&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.is_admin, is_admin) || other.is_admin == is_admin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,email,password,is_admin);

@override
String toString() {
  return 'UserCreate(username: $username, email: $email, password: $password, is_admin: $is_admin)';
}


}

/// @nodoc
abstract mixin class $UserCreateCopyWith<$Res>  {
  factory $UserCreateCopyWith(UserCreate value, $Res Function(UserCreate) _then) = _$UserCreateCopyWithImpl;
@useResult
$Res call({
 String username, String email, String password, bool is_admin
});




}
/// @nodoc
class _$UserCreateCopyWithImpl<$Res>
    implements $UserCreateCopyWith<$Res> {
  _$UserCreateCopyWithImpl(this._self, this._then);

  final UserCreate _self;
  final $Res Function(UserCreate) _then;

/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? email = null,Object? password = null,Object? is_admin = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,is_admin: null == is_admin ? _self.is_admin : is_admin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserCreate implements UserCreate {
  const _UserCreate({required this.username, required this.email, required this.password, required this.is_admin});
  factory _UserCreate.fromJson(Map<String, dynamic> json) => _$UserCreateFromJson(json);

@override final  String username;
@override final  String email;
@override final  String password;
@override final  bool is_admin;

/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCreateCopyWith<_UserCreate> get copyWith => __$UserCreateCopyWithImpl<_UserCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserCreate&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.is_admin, is_admin) || other.is_admin == is_admin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,email,password,is_admin);

@override
String toString() {
  return 'UserCreate(username: $username, email: $email, password: $password, is_admin: $is_admin)';
}


}

/// @nodoc
abstract mixin class _$UserCreateCopyWith<$Res> implements $UserCreateCopyWith<$Res> {
  factory _$UserCreateCopyWith(_UserCreate value, $Res Function(_UserCreate) _then) = __$UserCreateCopyWithImpl;
@override @useResult
$Res call({
 String username, String email, String password, bool is_admin
});




}
/// @nodoc
class __$UserCreateCopyWithImpl<$Res>
    implements _$UserCreateCopyWith<$Res> {
  __$UserCreateCopyWithImpl(this._self, this._then);

  final _UserCreate _self;
  final $Res Function(_UserCreate) _then;

/// Create a copy of UserCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? email = null,Object? password = null,Object? is_admin = null,}) {
  return _then(_UserCreate(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,is_admin: null == is_admin ? _self.is_admin : is_admin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PaginatedUsers {

 int get total; int get page; int get per_page; List<UserInfo> get items;
/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedUsersCopyWith<PaginatedUsers> get copyWith => _$PaginatedUsersCopyWithImpl<PaginatedUsers>(this as PaginatedUsers, _$identity);

  /// Serializes this PaginatedUsers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedUsers&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.per_page, per_page) || other.per_page == per_page)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,page,per_page,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PaginatedUsers(total: $total, page: $page, per_page: $per_page, items: $items)';
}


}

/// @nodoc
abstract mixin class $PaginatedUsersCopyWith<$Res>  {
  factory $PaginatedUsersCopyWith(PaginatedUsers value, $Res Function(PaginatedUsers) _then) = _$PaginatedUsersCopyWithImpl;
@useResult
$Res call({
 int total, int page, int per_page, List<UserInfo> items
});




}
/// @nodoc
class _$PaginatedUsersCopyWithImpl<$Res>
    implements $PaginatedUsersCopyWith<$Res> {
  _$PaginatedUsersCopyWithImpl(this._self, this._then);

  final PaginatedUsers _self;
  final $Res Function(PaginatedUsers) _then;

/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? page = null,Object? per_page = null,Object? items = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,per_page: null == per_page ? _self.per_page : per_page // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<UserInfo>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PaginatedUsers implements PaginatedUsers {
  const _PaginatedUsers({required this.total, required this.page, required this.per_page, required final  List<UserInfo> items}): _items = items;
  factory _PaginatedUsers.fromJson(Map<String, dynamic> json) => _$PaginatedUsersFromJson(json);

@override final  int total;
@override final  int page;
@override final  int per_page;
 final  List<UserInfo> _items;
@override List<UserInfo> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedUsersCopyWith<_PaginatedUsers> get copyWith => __$PaginatedUsersCopyWithImpl<_PaginatedUsers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedUsersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedUsers&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.per_page, per_page) || other.per_page == per_page)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,page,per_page,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PaginatedUsers(total: $total, page: $page, per_page: $per_page, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PaginatedUsersCopyWith<$Res> implements $PaginatedUsersCopyWith<$Res> {
  factory _$PaginatedUsersCopyWith(_PaginatedUsers value, $Res Function(_PaginatedUsers) _then) = __$PaginatedUsersCopyWithImpl;
@override @useResult
$Res call({
 int total, int page, int per_page, List<UserInfo> items
});




}
/// @nodoc
class __$PaginatedUsersCopyWithImpl<$Res>
    implements _$PaginatedUsersCopyWith<$Res> {
  __$PaginatedUsersCopyWithImpl(this._self, this._then);

  final _PaginatedUsers _self;
  final $Res Function(_PaginatedUsers) _then;

/// Create a copy of PaginatedUsers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? page = null,Object? per_page = null,Object? items = null,}) {
  return _then(_PaginatedUsers(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,per_page: null == per_page ? _self.per_page : per_page // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<UserInfo>,
  ));
}


}

// dart format on
