import 'package:volo_meeting/index.dart';
import 'package:volo_meeting/service/meeting_room.dart';

class MeetingPage extends ConsumerStatefulWidget {
  const MeetingPage({
    super.key,
    required this.meetingId,
  });

  final String meetingId;

  @override
  ConsumerState<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends ConsumerState<MeetingPage> {
  late final MeetingRoom meetingRoom = MeetingRoom(
    meetingId: widget.meetingId,
    baseUrl: Uri.parse('ws://12.34.5.6/'),
    device: Device(
      id: ref.watch(settingsProvider).deviceId,
      nickname: ref.watch(settingsProvider).nickname,
    ),
  );

  final preview = RTCPreviewController();

  @override
  void initState() {
    super.initState();
    VoloMeeting.printLog('init MeetingPage');
    VoloMeeting.printLog('init MeetingPage end');
  }

  @override
  void dispose() {
    // TODO: meetingRoom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VoloMeeting.printLog('build MeetingPage');

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: context.pop,
          child: const Text(
            '结束',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: const Text(VoloMeeting.appName),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.zoom_in_map_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              true ? CupertinoIcons.speaker_2_fill : CupertinoIcons.ear,
            ),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final row = constraints.maxWidth > 480 ? 2 : 1;
            final double width =
                constraints.maxWidth > 960 ? 480 : constraints.maxWidth / row;

            return Wrap(
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      width: width,
                      child: RTCVideoView(
                        renderer: preview.renderer,
                      ),
                    ),
                    Container(
                      color: Colors.black.withAlpha(128),
                      width: width,
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(
                  width: width,
                  child: RTCVideoView(
                    renderer: preview.renderer,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: RTCVideoView(
                    renderer: preview.renderer,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: RTCVideoView(
                    renderer: preview.renderer,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.mic_rounded),
            label: '静音',
          ),
          NavigationDestination(
            icon: Icon(Icons.videocam_off_rounded),
            label: '开启视频',
          ),
          NavigationDestination(
            icon: Icon(Icons.screen_share_rounded),
            label: '共享屏幕',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_rounded),
            label: '管理成员(1)',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded),
            label: '更多',
          ),
        ],
      ),
    );
  }
}
