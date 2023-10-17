import 'package:volo_meeting/index.dart';
part 'rtc_ice_candidate.freezed.dart';
part 'rtc_ice_candidate.g.dart';

@freezed
class RTCIceCandidate with _$RTCIceCandidate {
  const RTCIceCandidate._();

  const factory RTCIceCandidate(
    String? candidate,
    String? sdpMid,
    int? sdpMLineIndex,
  ) = _RTCIceCandidate;

  Map<String, Object?> toMap() => {
        'candidate': candidate,
        'sdpMid': sdpMid,
        'sdpMLineIndex': sdpMLineIndex,
      };

  factory RTCIceCandidate.fromJson(Map<String, Object?> json) =>
      _$RTCIceCandidateFromJson(json);
}
