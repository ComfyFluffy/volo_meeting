import 'package:volo_meeting/index.dart';
part 'rtc_ice_candidate.freezed.dart';
part 'rtc_ice_candidate.g.dart';

@freezed
class MyRTCIceCandidate with _$MyRTCIceCandidate {
  const MyRTCIceCandidate._();

  const factory MyRTCIceCandidate(
    String? candidate,
    String? sdpMid,
    int? sdpMLineIndex,
  ) = _RTCIceCandidate;

  Map<String, Object?> toMap() => toJson();

  factory MyRTCIceCandidate.fromJson(Map<String, Object?> json) =>
      _$MyRTCIceCandidateFromJson(json);

  RTCIceCandidate toRTCIceCandidate() => RTCIceCandidate(
        candidate,
        sdpMid,
        sdpMLineIndex,
      );

  factory MyRTCIceCandidate.fromRTCIceCandidate(RTCIceCandidate candidate) =>
      MyRTCIceCandidate(
        candidate.candidate,
        candidate.sdpMid,
        candidate.sdpMLineIndex,
      );
}
