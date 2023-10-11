import 'dart:math';

import 'package:volo_meeting/index.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const _HomeAvatar(),
        title: Text(settings.username),
        centerTitle: false,
      ),
      drawer: const HomePageDrawer(),
      body: const HomePageBody(),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({
    super.key,
  });

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 360,
              child: BasedListSection(
                mainAxisSize: MainAxisSize.min,
                itemPadding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '请输入会议号',
                      border: OutlineInputBorder(),
                      labelText: '会议号',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: FilledButton(
            onPressed: () {
              if (_controller.text.isInt) {
                context.push(const JoinMeetPage());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请检查会议号')),
                );
              }
            },
            child: const Text('加入会议'),
          ),
        ),
      ],
    );
  }
}

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

    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {},
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia(
        mediaConstraints,
      );

      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      VoloMeeting.printLog(e);
    }
  }

  @override
  void dispose() {
    close();
    navigator.mediaDevices.ondevicechange = null;
    super.dispose();
  }

  void close() async {
    try {
      if (kIsWeb) {
        _localStream.getTracks().forEach((track) => track.stop());
      }
      await _localStream.dispose();
      _localRenderer.srcObject = null;
    } catch (e) {
      VoloMeeting.printLog(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BasedListView(
        children: [
          BasedListSection(
            children: [
              RTCVideoView(_localRenderer),
              VideoEnableTile(value: true, onChanged: (value) {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar();

  @override
  Widget build(BuildContext context) {
    return BasedAvatar(
      onTap: Scaffold.of(context).openDrawer,
      badge: const Badge(
        backgroundColor: Colors.green,
      ),
    );
  }
}

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SafeArea(
        child: BasedListView(
          children: [
            ProfileTile(),
            BasedListSection(
              elevation: 0,
              children: [
                AccountSecureTile(),
                SettingsTile(),
                HelpServiceTile(),
                AboutUsTile(),
              ],
            ),
            BasedListSection(
              elevation: 0,
              children: [
                LogoutTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RTCVideoView extends StatelessWidget {
  const RTCVideoView(
    this._renderer, {
    super.key,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  });

  final RTCVideoRenderer _renderer;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  RTCVideoRenderer get videoRenderer => _renderer;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: videoRenderer,
      builder: (context, value, child) {
        /// FIXME: find a way to limit the width and height
        return AspectRatio(
          aspectRatio: value.aspectRatio,
          child: videoRenderer.renderVideo
              ? Texture(
                  textureId: videoRenderer.textureId!,
                  filterQuality: filterQuality,
                )
              : placeholderBuilder?.call(context) ??
                  const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
