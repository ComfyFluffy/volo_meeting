import 'package:volo_meeting/index.dart';

class JoinMeetPage extends ConsumerStatefulWidget {
  const JoinMeetPage({
    super.key,
  });

  @override
  ConsumerState<JoinMeetPage> createState() => _JoinMeetPageState();
}

class _JoinMeetPageState extends ConsumerState<JoinMeetPage> {
  late final RTCPreviewController _controller = RTCPreviewController(
    mediaConstraints: const MediaConstraints(
      audio: true,
      video: {
        'facingMode': 'user',
      },
    ),
    videoEnabled: ref.watch(settingsProvider).enableVideo,
    audioEnabled: ref.watch(settingsProvider).enableAudio,
  );

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.watch(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('会议设置'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: RTCVideoView(controller: _controller),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: BasedListView(
              children: [
                BasedListSection(
                  children: [
                    VideoEnableTile(
                      value: settings.enableVideo,
                      onChanged: (value) {
                        notifier.setEnableVideo(value);
                        setState(() {
                          _controller.setMediaEnabled(video: value);
                        });
                      },
                    ),
                    AudioEnableTile(
                      value: settings.enableAudio,
                      onChanged: (value) {
                        notifier.setEnableAudio(value);
                        setState(() {
                          _controller.setMediaEnabled(audio: value);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
