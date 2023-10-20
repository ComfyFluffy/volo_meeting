import 'package:volo_meeting/index.dart';

class RTCVideoView extends StatelessWidget {
  const RTCVideoView({
    required this.renderer,
    super.key,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  });

  final RTCVideoRenderer renderer;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder(
          valueListenable: renderer,
          builder: (context, value, child) {
            final hasVideo =
                renderer.renderVideo && value.width * value.height != 0;

            return AspectRatio(
              aspectRatio: hasVideo
                  ? value.aspectRatio
                  : MediaQuery.of(context).size.aspectRatio,
              child: hasVideo
                  ? Texture(
                      textureId: renderer.textureId!,
                      filterQuality: filterQuality,
                    )
                  : const ColoredBox(color: Colors.black),
            );
          },
        ),
      ),
    );
  }
}

class RTCPreviewController extends ChangeNotifier {
  final _renderer = RTCVideoRenderer();
  RTCVideoRenderer get renderer => _renderer;

  late MediaConstraints _constraints;
  MediaConstraints get mediaConstraints => _constraints;

  late List<MediaDeviceInfo> _devicesList;
  List<MediaDeviceInfo> get devicesList => _devicesList;

  late MediaStream _localStream;

  bool _started = false;

  bool _videoEnabled = true;
  bool _audioEnabled = true;

  get videoEnabled => _videoEnabled;
  get audioEnabled => _audioEnabled;

  @override
  String toString() => mediaConstraints.toJson().toString();

  RTCPreviewController({
    MediaConstraints mediaConstraints = const MediaConstraints(
      audio: true,
      video: {'facingMode': 'user'},
    ),
    videoEnabled = true,
    audioEnabled = true,
  }) {
    /// set mediaConstraints
    _constraints = mediaConstraints;
    _videoEnabled = videoEnabled;
    _audioEnabled = audioEnabled;

    /// init renderer
    renderer.initialize();

    /// setup listener
    navigator.mediaDevices.ondevicechange = (event) async {
      _devicesList = await navigator.mediaDevices.enumerateDevices();
      notifyListeners();
    };

    start();
  }

  @override
  void dispose() {
    /// dispose stream
    _localStream.getTracks().forEach((track) => track.stop());
    _localStream.dispose();

    /// cleanup listener
    navigator.mediaDevices.ondevicechange = null;

    /// dispose renderer
    renderer.dispose();

    super.dispose();
  }

  Future<void> start() async {
    if (_started) return;

    _devicesList = await navigator.mediaDevices.enumerateDevices();
    _localStream = await navigator.mediaDevices.getUserMedia(
      {
        'audio': _audioEnabled ? _constraints.audio : false,
        'video': _videoEnabled ? _constraints.video : false,
      },
    );
    renderer.srcObject = _localStream;

    _started = true;

    notifyListeners();
  }

  void close() {
    if (!_started) return;

    _localStream.getTracks().forEach((track) => track.stop());
    renderer.srcObject = null;
    _localStream.dispose();
    _started = false;

    notifyListeners();
  }

  void setMediaConstraints(
    MediaConstraints mediaConstraints,
  ) {
    _constraints = mediaConstraints;

    close();
    start();
  }

  void setMediaEnabled({
    bool? audio,
    bool? video,
  }) {
    _audioEnabled = audio ?? _audioEnabled;
    _videoEnabled = video ?? _videoEnabled;

    close();
    start();
  }
}

class MediaConstraints {
  const MediaConstraints({
    this.audio,
    this.video,
  });

  final dynamic audio;
  final dynamic video;

  @override
  String toString() => toJson().toString();

  Map<String, dynamic> toJson() => {
        'audio': audio,
        'video': video,
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
