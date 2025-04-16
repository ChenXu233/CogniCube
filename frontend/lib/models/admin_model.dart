import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_model.freezed.dart';
part 'admin_model.g.dart';

/// 用户信息
@freezed
abstract class UserInfo with _$UserInfo {
  const factory UserInfo({
    required int id,
    required String username,
    required String email,
    required bool is_admin,
    required bool is_verified,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}

/// 创建用户时使用的模型（包含 password）
@freezed
abstract class UserCreate with _$UserCreate {
  const factory UserCreate({
    required String username,
    required String email,
    required String password,
    required bool is_admin,
  }) = _UserCreate;

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);
}

/// 分页用户数据
@freezed
abstract class PaginatedUsers with _$PaginatedUsers {
  const factory PaginatedUsers({
    required int total,
    required int page,
    required int per_page,
    required List<UserInfo> items,
  }) = _PaginatedUsers;

  factory PaginatedUsers.fromJson(Map<String, dynamic> json) =>
      _$PaginatedUsersFromJson(json);
}
