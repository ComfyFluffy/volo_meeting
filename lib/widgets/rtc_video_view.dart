import 'package:volo_meeting/index.dart';

class RTCVideoView extends StatefulWidget {
  const RTCVideoView({
    required this.localController,
    super.key,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  });

  final RTCVideoController localController;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  @override
  State<RTCVideoView> createState() => _RTCVideoViewState();
}

class _RTCVideoViewState extends State<RTCVideoView> {
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    initWebRTC();
  }

  @override
  void dispose() {
    remoteRenderer.dispose();
    super.dispose();
  }

  void initWebRTC() async {
    print('initWebRTC');
    await widget.localController.start();
    final configuration = {'sdpSemantics': 'unified-plan'};
    final pc1 = await createPeerConnection(configuration);
    final pc2 = await createPeerConnection(configuration);

    pc1.onIceCandidate = (candidate) {
      print('pc1 ice: ${candidate.candidate}');
      pc2.addCandidate(candidate);
    };
    pc2.onIceCandidate = (candidate) {
      print('pc2 ice: ${candidate.candidate}');
      pc1.addCandidate(candidate);
    };

    pc1.onIceConnectionState = (state) {
      print('pc1 connection: $state');
    };
    pc2.onIceConnectionState = (state) {
      print('pc2 connection: $state');
    };

    print('addTrack');
    widget.localController._localStream.getTracks().forEach((track) {
      print('${track.kind} ${track.id}');
      pc1.addTrack(track, widget.localController._localStream);
    });

    await pc2.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));
    await pc2.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly));

    pc2.onAddTrack = (stream, track) {
      print('addTrack: ${stream.id} ${track.kind} ${track.id}');
      remoteRenderer.srcObject = stream;
    };

    final offer = await pc1.createOffer({});
    await pc1.setLocalDescription(offer);
    await pc2.setRemoteDescription(offer);

    final answer = await pc2.createAnswer({});
    await pc2.setLocalDescription(answer);
    await pc1.setRemoteDescription(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ValueListenableBuilder(
              valueListenable: widget.localController.renderer,
              builder: (context, value, child) {
                final hasVideo = widget.localController.renderer.renderVideo &&
                    value.width * value.height != 0;

                return AspectRatio(
                  aspectRatio: hasVideo ? value.aspectRatio : 480 / 640,
                  child: hasVideo
                      ? Texture(
                          textureId: widget.localController.renderer.textureId!,
                          filterQuality: widget.filterQuality,
                        )
                      : const ColoredBox(color: Colors.black),
                );
              },
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ValueListenableBuilder(
              valueListenable: remoteRenderer,
              builder: (context, value, child) {
                final hasVideo =
                    value.renderVideo && value.width * value.height != 0;

                return AspectRatio(
                  aspectRatio: hasVideo ? value.aspectRatio : 480 / 640,
                  child: hasVideo
                      ? Texture(
                          textureId: remoteRenderer.textureId!,
                          filterQuality: widget.filterQuality,
                        )
                      : const ColoredBox(color: Colors.black),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RTCVideoController extends ChangeNotifier {
  final _renderer = RTCVideoRenderer();
  RTCVideoRenderer get renderer => _renderer;

  late MediaConstraints _constraints;
  MediaConstraints get mediaConstraints => _constraints;

  late List<MediaDeviceInfo> _devicesList;
  List<MediaDeviceInfo> get devicesList => _devicesList;

  late MediaStream _localStream;

  bool _enable = false;

  @override
  String toString() => mediaConstraints.toJson().toString();

  RTCVideoController({
    MediaConstraints? mediaConstraints,
    bool autoStart = true,
  }) {
    /// set mediaConstraints
    _constraints = mediaConstraints ?? const MediaConstraints();

    /// init renderer
    renderer.initialize();

    /// setup listener
    navigator.mediaDevices.ondevicechange = (event) async {
      _devicesList = await navigator.mediaDevices.enumerateDevices();
      notifyListeners();
    };

    if (autoStart) start();
  }

  @override
  void dispose() {
    /// dispose stream
    _localStream.dispose();

    /// cleanup listener
    navigator.mediaDevices.ondevicechange = null;

    /// dispose renderer
    renderer.dispose();

    super.dispose();
  }

  Future<void> start() async {
    if (_enable) return;

    try {
      _devicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = await navigator.mediaDevices.getUserMedia(
        _constraints.toJson(),
      );
      renderer.srcObject = _localStream;
    } catch (e) {
      VoloMeeting.printLog(e);
    }
    _enable = true;

    notifyListeners();
  }

  void close() {
    if (!_enable) return;

    _localStream.getTracks().forEach((track) => track.stop());
    renderer.srcObject = null;
    _localStream.dispose();
    _enable = false;

    notifyListeners();
  }

  void setMediaConstraints(
    MediaConstraints mediaConstraints,
  ) {
    close();
    _constraints = mediaConstraints;
    start();
  }
}

class MediaConstraints {
  const MediaConstraints({
    this.audio = true,
    this.video = true,
  });

  final dynamic audio;
  final dynamic video;

  bool get enableAudio => audio is bool ? audio : false;

  bool get enableVideo => video is bool ? video : false;

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
        'audio': audio ?? false,
        'video': video ?? false,
      };

  MediaConstraints copyWith({
    dynamic audio,
    dynamic video,
  }) =>
      MediaConstraints(
        audio: audio ?? this.audio,
        video: video ?? this.video,
      );
}
