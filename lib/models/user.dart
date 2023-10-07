import 'package:volo_meeting/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
  }) = _User;

  const User._();

  String toJsonString() => jsonEncode(toJson());
  User fromJsonString(String str) => User.fromJson(jsonDecode(str));

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
