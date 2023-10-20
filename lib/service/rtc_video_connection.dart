import 'package:volo_meeting/index.dart';

class RemoteDeviceState {
  bool micOn;
  bool cameraOn;
  bool muted;

  RemoteDeviceState({
    required this.micOn,
    required this.cameraOn,
    required this.muted,
  });
}

void _setUpDebugLogForPc(RTCPeerConnection pc, Device device) {
  const log = VoloMeeting.printLog;

  pc.onSignalingState = (state) async {
    log('pc for device $device: onSignalingState($state)');
  };
  pc.onIceGatheringState = (state) async {
    log('pc for device $device: onIceGatheringState($state)');
  };
  pc.onIceConnectionState = (state) async {
    log('pc for device $device: onIceConnectionState($state)');
  };
  pc.onConnectionState = (state) async {
    log('pc for device $device: onConnectionState($state)');
  };
}

class RemoteDeviceConnection {
  final Device localDevice;
  RemoteDeviceState state;

  final RTCPeerConnection peerConnection;

  MediaStream? _remoteStream;

  get remoteStream => _remoteStream;

  RemoteDeviceConnection({
    required this.localDevice,
    required this.peerConnection,
    required this.state,
  });

  static Future<RemoteDeviceConnection> create({
    required Device localDevice,
    required Device remoteDevice,
    required void Function(RTCIceCandidate) onIceCandidate,
    required void Function(RTCSessionDescription) onCreateOffer,
  }) async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
      'encodedInsertableStreams': true,
    };
    final peerConnection = await createPeerConnection(configuration);

    final connection = RemoteDeviceConnection(
      localDevice: remoteDevice,
      peerConnection: peerConnection,
      state: RemoteDeviceState(
        micOn: true,
        cameraOn: true,
        muted: false,
      ),
    );

    peerConnection.onIceCandidate = onIceCandidate;
    peerConnection.onTrack = (event) {
      if (event.track.kind == 'video') {
        VoloMeeting.printLog('Received remote video track');
        connection._remoteStream = event.streams[0];
      }
    };

    _setUpDebugLogForPc(peerConnection, remoteDevice);

    Future(() async {
      if (localDevice.id < remoteDevice.id) return;

      final offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);
      onCreateOffer(offer);
    });

    return connection;
  }

  Future<void> dispose() async {
    await _remoteStream?.dispose();
    await peerConnection.dispose();
  }

  Future<RTCSessionDescription> createAnswer(
    RTCSessionDescription offer,
  ) async {
    await peerConnection.setRemoteDescription(offer);
    final answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);
    return answer;
  }

  void updateLocalStream(MediaStream stream) {
    peerConnection.addStream(stream);
  }

  void updateState(RemoteDeviceState state) {
    this.state = state;
  }
}
