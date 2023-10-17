import 'package:volo_meeting/index.dart';
part 'rtc_session_description.freezed.dart';
part 'rtc_session_description.g.dart';

@freezed
class RTCSessionDescription with _$RTCSessionDescription {
  const RTCSessionDescription._();

  const factory RTCSessionDescription(String? sdp, String? type) =
      _RTCSessionDescription;

  Map<String, Object?> toMap() => {'sdp': sdp, 'type': type};

  factory RTCSessionDescription.fromJson(Map<String, Object?> json) =>
      _$RTCSessionDescriptionFromJson(json);
}
