import 'package:volo_meeting/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'settings.g.dart';

@riverpod
class Settings extends _$Settings {
  late Persistence _persistence;

  @override
  SettingsState build() {
    _persistence = ref.watch(persistenceProvider);
    return SettingsState(
      username: _persistence.getUsername(),
      deviceId: _persistence.getDeviceId(),
    );
  }

  Future<void> setUsername(String username) async {
    await _persistence.setUsername(username);
    state = state.copyWith(username: username);
  }

  Future<void> randomDeviceId() async {
    final deviceId = nanoid();
    await _persistence.setDeviceId(deviceId);
    state = state.copyWith(deviceId: deviceId);
  }
}
