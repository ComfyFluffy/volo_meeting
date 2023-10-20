import 'package:volo_meeting/index.dart';
part 'message_data.freezed.dart';
part 'message_data.g.dart';

@freezed
class DescriptionMessageData with _$DescriptionMessageData {
  const DescriptionMessageData._();

  const factory DescriptionMessageData({
    required String id,
    required MyRTCSessionDescription content,
  }) = _DescriptionMessageData;

  factory DescriptionMessageData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DescriptionMessageDataFromJson(json);
}

@freezed
class IceCandidateMessageData with _$IceCandidateMessageData {
  const IceCandidateMessageData._();

  const factory IceCandidateMessageData({
    required String id,
    required MyRTCIceCandidate content,
  }) = _IceCandidateMessageData;

  factory IceCandidateMessageData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$IceCandidateMessageDataFromJson(json);

  RTCIceCandidate toRTCIceCandidate() {
    return RTCIceCandidate(
      content.candidate,
      content.sdpMid,
      content.sdpMLineIndex,
    );
  }
}

@freezed
class ErrorMessageData with _$ErrorMessageData {
  const ErrorMessageData._();

  const factory ErrorMessageData({
    required int code,
    required String type,
    required String msg,
  }) = _ErrorMessageData;

  factory ErrorMessageData.fromJson(Map<String, Object?> json) =>
      _$ErrorMessageDataFromJson(json);
}
