// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => _UserInfo(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  is_admin: json['is_admin'] as bool,
  is_verified: json['is_verified'] as bool,
);

Map<String, dynamic> _$UserInfoToJson(_UserInfo instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'is_admin': instance.is_admin,
  'is_verified': instance.is_verified,
};

_UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => _UserCreate(
  username: json['username'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  is_admin: json['is_admin'] as bool,
);

Map<String, dynamic> _$UserCreateToJson(_UserCreate instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'is_admin': instance.is_admin,
    };

_PaginatedUsers _$PaginatedUsersFromJson(Map<String, dynamic> json) =>
    _PaginatedUsers(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      per_page: (json['per_page'] as num).toInt(),
      items:
          (json['items'] as List<dynamic>)
              .map((e) => UserInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PaginatedUsersToJson(_PaginatedUsers instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'per_page': instance.per_page,
      'items': instance.items,
    };
