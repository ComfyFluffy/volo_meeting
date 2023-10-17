import 'package:volo_meeting/index.dart';
part 'meeting.freezed.dart';
part 'meeting.g.dart';

@freezed
class Meeting with _$Meeting {
  const factory Meeting({
    required String id,
    @JsonKey(name: 'friendly_id') required String friendlyId,
    required User creator,
    required String topic,
    @EpochDateTimeConverter()
    @JsonKey(name: 'booked_start_time')
    required DateTime bookedStartTime,
    @EpochDateTimeConverter()
    @JsonKey(name: 'booked_end_time')
    required DateTime bookedEndTime,
    @EpochDateTimeConverter()
    @JsonKey(name: 'start_time')
    required DateTime startTime,
    @EpochDateTimeConverter()
    @JsonKey(name: 'end_time')
    required DateTime endTime,
  }) = _Meeting;

  const Meeting._();

  String toJsonString() => jsonEncode(toJson());
  Meeting fromJsonString(String str) => Meeting.fromJson(jsonDecode(str));

  factory Meeting.fromJson(Map<String, Object?> json) =>
      _$MeetingFromJson(json);
}
