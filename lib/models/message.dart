import 'package:volo_meeting/index.dart';
part 'message.freezed.dart';
part 'message.g.dart';

/// For more info about [Message], see [Document](https://ncuhomer.feishu.cn/docx/GI5ldBfJhoCC3txFKMacviTjnyl)
@Freezed(unionKey: 'event')
class Message with _$Message {
  const Message._();

  const factory Message.description({
    required List<DescriptionMessageData> data,
  }) = DescriptionMessage;

  const factory Message.iceCandidate({
    required List<IceCandidateMessageData> data,
  }) = IceCandidateMessage;

  // @FreezedUnionValue('device')
  // const factory Message.updateDevice({
  //   required String id,
  //   required Device data,
  // }) = UpdateDeviceMessage;

  @FreezedUnionValue('member')
  const factory Message.members({
    required List<Device> data,
  }) = MembersMessage;

  @FreezedUnionValue('join')
  const factory Message.memberJoined({
    required List<Device> data,
  }) = MemberJoinedMessage;

  // const factory Message.keepAlive() = KeepAliveMessage;

  @FreezedUnionValue('leave')
  const factory Message.memberLeft({
    required String data,
  }) = MemberLeftMessage;

  const factory Message.error({
    required String id,
    required ErrorMessageData data,
  }) = ErrorMessage;

  String toJsonString() => jsonEncode(toJson());
  Message fromJsonString(String str) => Message.fromJson(jsonDecode(str));

  factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);
}
