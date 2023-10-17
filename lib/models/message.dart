import 'package:volo_meeting/index.dart';
part 'message.freezed.dart';
part 'message.g.dart';

/// For more info about [Message], see [Document](https://ncuhomer.feishu.cn/docx/GI5ldBfJhoCC3txFKMacviTjnyl)
@Freezed(unionKey: 'event')
class Message with _$Message {
  const Message._();

  const factory Message.description({
    required String id,
    required List<DescriptionMessageData> data,
  }) = DescriptionMessage;

  const factory Message.iceCandidate({
    required String id,
    required List<CandidateMessageData> data,
  }) = CandidateMessage;

  const factory Message.device({
    required String id,
    required Device data,
  }) = DeviceMessage;

  const factory Message.member({
    required String id,
    required Device data,
  }) = MemberMessage;

  const factory Message.keepAlive() = KeepAliveMessage;
  const factory Message.leave() = LeaveMessage;

  const factory Message.error({
    required String id,
    required ErrorMessageData data,
  }) = ErrorMessage;

  const factory Message.response({
    required String id,
    required dynamic data,
  }) = ResponseMessage;

  String toJsonString() => jsonEncode(toJson());
  Message fromJsonString(String str) => Message.fromJson(jsonDecode(str));

  factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);
}
