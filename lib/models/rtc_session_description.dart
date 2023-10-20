import 'package:volo_meeting/index.dart';
part 'rtc_session_description.freezed.dart';
part 'rtc_session_description.g.dart';

@freezed
class MyRTCSessionDescription with _$MyRTCSessionDescription {
  const MyRTCSessionDescription._();

  const factory MyRTCSessionDescription(
    String? sdp,
    String? type,
  ) = _MyRTCSessionDescription;

  Map<String, Object?> toMap() => toJson();

  factory MyRTCSessionDescription.fromJson(Map<String, Object?> json) =>
      _$MyRTCSessionDescriptionFromJson(json);

  RTCSessionDescription toRTCSessionDescription() => RTCSessionDescription(
        sdp,
        type,
      );
}
