import 'package:volo_meeting/index.dart';
part 'settings.g.dart';
part 'settings.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @JsonKey(name: 'nickname') required String nickname,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'enable_video') required bool enableVideo,
    @JsonKey(name: 'enable_audio') required bool enableAudio,
  }) = _Settings;

  const SettingsState._();

  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
