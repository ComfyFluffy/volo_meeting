import 'package:volo_meeting/index.dart';
part 'settings_state.g.dart';
part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @JsonKey(name: 'username') required String? username,
    @JsonKey(name: 'device_id') required String? deviceId,
  }) = _SettingState;

  const SettingsState._();

  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
