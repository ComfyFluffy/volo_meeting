import 'package:volo_meeting/index.dart';

class JoinMeetPage extends StatefulWidget {
  const JoinMeetPage({
    super.key,
  });

  @override
  State<JoinMeetPage> createState() => _JoinMeetPageState();
}

class _JoinMeetPageState extends State<JoinMeetPage> {
  final _localRenderer = RTCVideoRenderer();
  late MediaStream _localStream;
  late List<MediaDeviceInfo> _mediaDevicesList;

  final _mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': true,
  };

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _localRenderer.initialize();

    navigator.mediaDevices.ondevicechange = (event) async {
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
    };

    try {
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = await navigator.mediaDevices.getUserMedia(
        _mediaConstraints,
      );
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      VoloMeeting.printLog(e);
    }
  }

  @override
  void dispose() {
    _localStream.dispose();
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BasedListView(
        children: [
          BasedListSection(
            children: [
              SizedBox(
                height: 200,
                child: RTCVideoView(_localRenderer),
              ),
              VideoEnableTile(
                value: _mediaConstraints['video'],
                onChanged: (value) async {
                  _mediaConstraints['video'] = value;
                  _localStream = await navigator.mediaDevices.getUserMedia(
                    {
                      'audio': true,
                      'video': false,
                    },
                  );
                  _localRenderer.srcObject = _localStream;
                  print(_mediaConstraints);
                  init();
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
