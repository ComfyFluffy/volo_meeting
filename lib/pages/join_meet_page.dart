import 'package:volo_meeting/index.dart';

class JoinMeetPage extends StatefulWidget {
  const JoinMeetPage({
    super.key,
  });

  @override
  State<JoinMeetPage> createState() => _JoinMeetPageState();
}

class _JoinMeetPageState extends State<JoinMeetPage> {
  final controller = RTCVideoController();

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
                child: RTCVideoView(controller: controller),
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
                      value: controller.mediaConstraints.enableVideo,
                      onChanged: (value) {
                        setState(() {
                          controller.setMediaConstraints(
                            controller.mediaConstraints.copyWith(video: value),
                          );
                        });
                      },
                    ),
                    MicEnableTile(
                      value: controller.mediaConstraints.enableAudio,
                      onChanged: (value) {
                        setState(() {
                          controller.setMediaConstraints(
                            controller.mediaConstraints.copyWith(audio: value),
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
