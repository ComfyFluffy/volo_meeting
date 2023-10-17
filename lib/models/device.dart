import 'package:volo_meeting/index.dart';
part 'device.freezed.dart';
part 'device.g.dart';

@freezed
class Device with _$Device {
  const Device._();

  const factory Device({
    required String id,
    required String nickname,
  }) = _Device;

  String toJsonString() => jsonEncode(toJson());
  Device fromJsonString(String str) => Device.fromJson(jsonDecode(str));

  factory Device.fromJson(Map<String, Object?> json) => _$DeviceFromJson(json);
}
