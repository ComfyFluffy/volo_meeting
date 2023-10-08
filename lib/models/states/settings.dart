import 'package:volo_meeting/index.dart';
part 'settings.g.dart';
part 'settings.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'device_id') required String deviceId,
  }) = _Settings;

  const SettingsState._();

  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
