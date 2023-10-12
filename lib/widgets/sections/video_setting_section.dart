import 'package:volo_meeting/index.dart';

class VideoSettingSection extends ConsumerWidget {
  const VideoSettingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.watch(settingsProvider.notifier);

    return BasedListSection(
      titleText: '视频',
      children: [
        VideoEnableTile(
          value: settings.enableVideo,
          onChanged: notifier.setEnableVideo,
        ),
        const VirtualBackgroundTile(),
        BasedSwitchListTile(
          value: true,
          onChanged: (value) {},
          leadingIcon: CupertinoIcons.square_split_2x1,
          titleText: '视频镜像',
        ),
        BasedSwitchListTile(
          value: true,
          onChanged: (value) {},
          leadingIcon: Icons.videocam_rounded,
          titleText: '视频降噪',
          subtitleText: '实时减少视频画面噪点，使画面更清晰',
        ),
      ],
    );
  }
}
