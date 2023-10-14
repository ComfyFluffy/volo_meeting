import 'package:volo_meeting/index.dart';

class JoinMeetPage extends ConsumerStatefulWidget {
  const JoinMeetPage({
    super.key,
  });

  @override
  ConsumerState<JoinMeetPage> createState() => _JoinMeetPageState();
}

class _JoinMeetPageState extends ConsumerState<JoinMeetPage> {
  late final RTCVideoController _controller = RTCVideoController(
    mediaConstraints: MediaConstraints(
      audio: ref.watch(settingsProvider).enableAudio,
      video: ref.watch(settingsProvider).enableVideo,
    ),
    autoStart: false,
  );

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('会议设置'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: RTCVideoView(localController: _controller),
          ),
          Expanded(
            flex: 3,
            child: BasedListView(
              children: [
                BasedListSection(
                  children: [
                    VideoEnableTile(
                      value: _controller.mediaConstraints.enableVideo,
                      onChanged: (value) {
                        notifier.setEnableVideo(value);
                        setState(() {
                          _controller.setMediaConstraints(
                            _controller.mediaConstraints.copyWith(video: value),
                          );
                        });
                      },
                    ),
                    AudioEnableTile(
                      value: _controller.mediaConstraints.enableAudio,
                      onChanged: (value) {
                        notifier.setEnableAudio(value);
                        setState(() {
                          _controller.setMediaConstraints(
                            _controller.mediaConstraints.copyWith(audio: value),
                          );
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
