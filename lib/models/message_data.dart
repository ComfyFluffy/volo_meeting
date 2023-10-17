import 'package:volo_meeting/index.dart';
part 'message_data.freezed.dart';
part 'message_data.g.dart';

@Freezed(genericArgumentFactories: true)
class DescriptionMessageData with _$DescriptionMessageData {
  const DescriptionMessageData._();

  const factory DescriptionMessageData({
    required String id,
    required List<RTCSessionDescription> content,
  }) = _DescriptionMessageData;

  factory DescriptionMessageData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DescriptionMessageDataFromJson(json);
}

@Freezed(genericArgumentFactories: true)
class CandidateMessageData with _$CandidateMessageData {
  const CandidateMessageData._();

  const factory CandidateMessageData({
    required String id,
    required List<RTCIceCandidate> content,
  }) = _CandidateMessageData;

  factory CandidateMessageData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CandidateMessageDataFromJson(json);
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
