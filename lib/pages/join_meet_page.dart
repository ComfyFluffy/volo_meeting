import 'package:volo_meeting/index.dart';

class JoinMeetPage extends StatefulWidget {
  const JoinMeetPage({
    super.key,
  });

  @override
  State<JoinMeetPage> createState() => _JoinMeetPageState();
}

class _JoinMeetPageState extends State<JoinMeetPage> {
  bool _using = false;
  final _localRenderer = RTCVideoRenderer();

  late MediaStream _localStream;
  late List<MediaDeviceInfo> _mediaDevicesList;

  @override
  void initState() {
    super.initState();

    /// init render
    _localRenderer.initialize();

    /// setup listener
    navigator.mediaDevices.ondevicechange = (event) async {
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
    };

    start();
  }

  @override
  void dispose() {
    ///
    if (_using) _localStream.dispose();

    /// cleanup listener
    navigator.mediaDevices.ondevicechange = null;

    /// dispose render
    _localRenderer.dispose();

    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void start({
    Map<String, dynamic> mediaConstraints = const {
      'audio': true,
      'video': true,
    },
  }) async {
    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      VoloMeeting.printLog(e);
    }
    if (mounted) setState(() => _using = true);
  }

  void close() {
    _localStream.getTracks().forEach((track) => track.stop());
    _localRenderer.srcObject = null;
    _localStream.dispose();
    if (mounted) setState(() => _using = false);
  }

  void setZoom(double zoomLevel) async {
    final videoTrack = _localStream
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await WebRTC.invokeMethod(
      'mediaStreamTrackSetZoom',
      <String, dynamic>{'trackId': videoTrack.id, 'zoomLevel': zoomLevel},
    );
  }

  void _toggleCamera() async {
    final videoTrack = _localStream
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _using
            ? [
                IconButton(
                  icon: const Icon(Icons.switch_video),
                  onPressed: _toggleCamera,
                ),
                PopupMenuButton<String>(
                  onSelected: _localRenderer.audioOutput,
                  itemBuilder: (context) => _mediaDevicesList
                      .where((device) => device.kind == 'audiooutput')
                      .map(
                        (device) => PopupMenuItem<String>(
                          value: device.deviceId,
                          child: Text(device.label),
                        ),
                      )
                      .toList(),
                ),
              ]
            : null,
      ),
      body: BasedListView(
        children: [
          BasedListSection(
            children: [
              SizedBox(
                height: 200,
                child: RTCVideoView(_localRenderer),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _using ? close : start,
        tooltip: _using ? 'Hangup' : 'Call',
        child: Icon(_using ? Icons.call_end : Icons.phone),
      ),
    );
  }
}
