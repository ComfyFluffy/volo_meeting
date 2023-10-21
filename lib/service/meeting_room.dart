import 'dart:collection';

import 'package:volo_meeting/index.dart';
import 'package:volo_meeting/service/rtc_video_connection.dart';

class MeetingRoom {
  final String meetingId;
  final Device localDevice;
  final LinkedHashMap<String, RemoteDeviceConnection> deviceConnections =
      LinkedHashMap();

  late final IOWebSocketChannel _channel;
  late final MediaStream _localStream;

  MeetingRoom._({
    required this.meetingId,
    required Uri baseUrl,
    required this.localDevice,
  });

  static MeetingRoom create({
    required String meetingId,
    required Uri baseUrl,
    required Device device,
  }) {
    final url = baseUrl.replace(
      queryParameters: {
        'meeting_id': meetingId,
        'id': device.id,
        'nickname': device.nickname,
      },
    );

    final channel = IOWebSocketChannel.connect(url);
    final meetingRoom = MeetingRoom._(
      meetingId: meetingId,
      baseUrl: baseUrl,
      localDevice: device,
    );
    meetingRoom._channel = channel;

    meetingRoom._initWebSocket();

    return meetingRoom;
  }

  Future<void> dispose() async {
    for (final deviceConnection in deviceConnections.values) {
      deviceConnection.dispose();
    }
    deviceConnections.clear();
    _localStream.dispose();
    _channel.sink.close();
  }

  void _initWebSocket() {
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
  }

  void _handleMessage(Message message) async {
    switch (message) {
      case DescriptionMessage(:final data):
        {
          for (final description in data) {
            final deviceConnection = deviceConnections[description.id];
            if (deviceConnection == null) {
              VoloMeeting.printLog(
                'Received description for unknown device ${description.id}',
              );
              continue;
            }
            deviceConnection.peerConnection.setRemoteDescription(
              description.content.toRTCSessionDescription(),
            );
          }
        }
      case IceCandidateMessage(:final data):
        {
          for (final iceCandidate in data) {
            final deviceConnection = deviceConnections[iceCandidate.id];
            if (deviceConnection == null) {
              VoloMeeting.printLog(
                'Received ICE candidate for unknown device ${iceCandidate.id}',
              );
              continue;
            }
            deviceConnection.peerConnection.addCandidate(
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

  Future<void> _addDeviceIfNotPresent(Device remoteDevice) async {
    if (deviceConnections[remoteDevice.id] != null) return;

    final deviceConnection = await RemoteDeviceConnection.create(
      localDevice: localDevice,
      remoteDevice: remoteDevice,
      onIceCandidate: (iceCandidate) => {
        _sendIceCandidate(remoteDevice, iceCandidate),
      },
      onCreateOffer: (offer) => {
        _sendDescription(remoteDevice, offer),
      },
    );

    // If the device was added while we were waiting for the connection to be
    // established, dispose of the new connection and return.
    if (deviceConnections[remoteDevice.id] != null) {
      deviceConnection.dispose();
      return;
    }

    deviceConnections[remoteDevice.id] = deviceConnection;
  }

  void _sendIceCandidate(
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

  void _sendDescription(
    Device to,
    RTCSessionDescription description,
  ) async {
    final message = Message.description(
      data: [
        DescriptionMessageData(
          id: to.id,
          content: MyRTCSessionDescription.fromRTCSessionDescription(
            description,
          ),
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
