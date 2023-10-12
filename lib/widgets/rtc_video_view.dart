import 'package:volo_meeting/index.dart';

class RTCVideoView extends StatelessWidget {
  const RTCVideoView({
    required this.controller,
    super.key,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  });

  final RTCVideoController controller;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder(
          valueListenable: controller.renderer,
          builder: (context, value, child) {
            final hasVideo = controller.renderer.renderVideo &&
                value.width * value.height != 0;

            return AspectRatio(
              aspectRatio: hasVideo
                  ? value.aspectRatio
                  : MediaQuery.of(context).size.aspectRatio,
              child: hasVideo
                  ? Texture(
                      textureId: controller.renderer.textureId!,
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

  void start() async {
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
