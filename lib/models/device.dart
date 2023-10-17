import 'package:volo_meeting/index.dart';
part 'device.freezed.dart';
part 'device.g.dart';

@freezed
class Device with _$Device {
  const factory Device({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'nickname') required String nickname,
  }) = _Device;

  const Device._();

  String toJsonString() => jsonEncode(toJson());
  Device fromJsonString(String str) => Device.fromJson(jsonDecode(str));

  factory Device.fromJson(Map<String, Object?> json) => _$DeviceFromJson(json);
}
