import 'package:volo_meeting/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'persistence.g.dart';

const _version = 'vm_version';
const _nickname = 'vm_nickname';
const _deviceId = 'vm_device_id';
const _enableVideo = 'vm_enable_video';
const _enableAudio = 'vm_enable_audio';

@riverpod
Persistence persistence(PersistenceRef ref) =>
    throw Exception('persistenceProvider not initialized');

/// This service abstracts the persistence layer.
class Persistence {
  final SharedPreferences _pref;

  Persistence._(this._pref);

  static Future<Persistence> init() async {
    SharedPreferences pref;
    try {
      pref = await SharedPreferences.getInstance();
    } catch (e) {
      throw Exception('Could not initialize SharedPreferences');
    }

    if (pref.getInt(_version).isNull) {
      await pref.setInt(_version, 1);
    }

    return Persistence._(pref);
  }

  String getNickname() => _pref.getString(_nickname) ?? '';
  Future<void> setNickname(String nickname) async =>
      await _pref.setString(_nickname, nickname);

  String getDeviceId() {
    final id = _pref.getString(_deviceId) ?? nanoid();
    setDeviceId(id);
    return id;
  }

  Future<void> setDeviceId(String deviceId) async =>
      await _pref.setString(_deviceId, deviceId);

  bool getEnableVideo() => _pref.getBool(_enableVideo) ?? true;
  Future<void> setEnableAudio(bool value) async =>
      await _pref.setBool(_enableAudio, value);

  bool getEnableAudio() => _pref.getBool(_enableAudio) ?? true;
  Future<void> setEnableVideo(bool value) async =>
      await _pref.setBool(_enableVideo, value);
}
