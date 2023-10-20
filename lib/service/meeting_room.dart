import 'dart:collection';

import 'package:volo_meeting/index.dart';
import 'package:volo_meeting/service/rtc_video_connection.dart';

class MeetingRoom {
  final String meetingId;
  final Device device;
  final HashMap<String, RemoteDeviceConnection> deviceConnections = HashMap();

  late final IOWebSocketChannel _channel;
  late final MediaStream _localStream;

  MeetingRoom({
    required this.meetingId,
    required Uri baseUrl,
    required this.device,
  }) {
    VoloMeeting.printLog('init MeetingRoom');

    final url = baseUrl.replace(
      queryParameters: {
        'meeting_id': meetingId,
        'id': device.id,
        'nickname': device.nickname,
      },
    );

    _channel = IOWebSocketChannel.connect(url);

    VoloMeeting.printLog('init MeetingRoom Websocket');
    _initWebSocket();
  }

  // Initialize WebSocket and listen for incoming messages
  void _initWebSocket() {
    VoloMeeting.printLog('init Websocket');

    _channel.stream.listen(
      (message) {
        if (message is! String) return;

        final data = Message.fromJson(jsonDecode(message));
        _handleMessage(data);
      },
      onError: (error) {
        VoloMeeting.printLog('WebSocket error: $error');
      },
      onDone: () {
        VoloMeeting.printLog('WebSocket closed');
      },
    );

    VoloMeeting.printLog('end Websocket');
  }

  // Handle incoming WebSocket messages
  void _handleMessage(Message message) async {
    switch (message) {
      case DescriptionMessage(:final data):
        {
          for (final description in data) {
            final deviceConnection = deviceConnections[description.id];
            deviceConnection?.peerConnection.setRemoteDescription(
              description.content.toRTCSessionDescription(),
            );
          }
        }
      case IceCandidateMessage(:final data):
        {
          for (final iceCandidate in data) {
            final deviceConnection = deviceConnections[iceCandidate.id];
            deviceConnection?.peerConnection.addCandidate(
              iceCandidate.content.toRTCIceCandidate(),
            );
          }
        }
      case MembersMessage(:final data):
        {
          for (final device in data) {
            await _addDeviceIfNotPresent(device);
          }
        }
      case MemberLeftMessage(:final data):
        {
          final deviceId = data;
          deviceConnections.remove(deviceId);
        }
    }
  }

  Future<void> _addDeviceIfNotPresent(Device device) async {
    if (deviceConnections[device.id] != null) return;

    final deviceConnection = await RemoteDeviceConnection.create(
      device: device,
      onIceCandidate: (iceCandidate) => {
        _sendIceCandidate(device, iceCandidate),
      },
    );
    deviceConnections[device.id] = deviceConnection;
  }

  Future<void> _sendIceCandidate(
    Device to,
    RTCIceCandidate iceCandidate,
  ) async {
    final message = Message.iceCandidate(
      data: [
        IceCandidateMessageData(
          id: to.id,
          content: MyRTCIceCandidate.fromRTCIceCandidate(iceCandidate),
        ),
      ],
    );
    sendMessage(message);
  }

  void sendMessage(Message message) {
    _channel.sink.add(message.toJsonString());
  }

  void close() {
    _channel.sink.close();
  }
}
