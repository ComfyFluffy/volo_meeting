import 'package:volo_meeting/index.dart';

class JoinMeetPage extends StatefulWidget {
  const JoinMeetPage({
    super.key,
  });

  @override
  State<JoinMeetPage> createState() => _JoinMeetPageState();
}

class _JoinMeetPageState extends State<JoinMeetPage> {
  final _controller = RTCVideoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                      value: _controller.mediaConstraints.enableVideo,
                      onChanged: (value) {
                        setState(() {
                          _controller.setMediaConstraints(
                            _controller.mediaConstraints.copyWith(video: value),
                          );
                        });
                      },
                    ),
                    MicEnableTile(
                      value: _controller.mediaConstraints.enableAudio,
                      onChanged: (value) {
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
