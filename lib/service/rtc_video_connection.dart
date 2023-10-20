import 'dart:collection';

import 'package:volo_meeting/index.dart';

class RemoteRTCView extends StatelessWidget {
  const RemoteRTCView({
    super.key,
    required this.remoteDeviceConnection,
  });

  final RemoteDeviceConnection remoteDeviceConnection;

  @override
  Widget build(BuildContext context) {
    return RTCVideoView(
      renderer: remoteDeviceConnection.remoteStream,
    );
  }
}

class RemoteDeviceState {
  final bool micOn;
  final bool cameraOn;
  final bool muted;

  const RemoteDeviceState({
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

class RemoteDeviceConnection extends ChangeNotifier {
  final Device device;
  RemoteDeviceState state;

  final RTCPeerConnection peerConnection;

  MediaStream? _localStream;

  MediaStream? _remoteStream;

  get remoteStream => _remoteStream;

  RemoteDeviceConnection._({
    required this.device,
    required this.peerConnection,
    required this.state,
  });

  static Future<RemoteDeviceConnection> create({
    required Device device,
    required void Function(RTCIceCandidate) onIceCandidate,
  }) async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
      'encodedInsertableStreams': true,
    };
    final peerConnection = await createPeerConnection(configuration);

    _setUpDebugLogForPc(peerConnection, device);

    peerConnection.onIceCandidate = onIceCandidate;

    return RemoteDeviceConnection._(
      device: device,
      peerConnection: peerConnection,
      state: const RemoteDeviceState(
        micOn: true,
        cameraOn: true,
        muted: false,
      ),
    );
  }

  void updateLocalStream(MediaStream stream) {
    _localStream = stream;
  }

  void updateState(RemoteDeviceState state) {
    this.state = state;
  }
}
