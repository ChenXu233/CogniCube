import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_model.freezed.dart';
part 'admin_model.g.dart';

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

extension UserInfoToJson on UserInfo {
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "is_admin": is_admin,
      "is_verified": is_verified,
    };
  }
}
