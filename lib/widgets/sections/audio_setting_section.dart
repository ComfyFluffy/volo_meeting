import 'package:volo_meeting/index.dart';

class AudioSettingSection extends ConsumerWidget {
  const AudioSettingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.watch(settingsProvider.notifier);

    return BasedListSection(
      titleText: '音频',
      children: [
        AudioEnableTile(
          value: settings.enableAudio,
          onChanged: notifier.setEnableAudio,
        ),
        SpeakerEnableTile(
          value: true,
          onChanged: (value) {},
        ),
        BasedSwitchListTile(
          value: true,
          onChanged: (value) {},
          leadingIcon: Icons.window_rounded,
          titleText: '开启麦克风浮窗',
        ),
        BasedSwitchListTile(
          value: true,
          onChanged: (value) {},
          leadingIcon: Icons.notifications_active_rounded,
          titleText: '开麦时播放提示音',
        ),
        BasedSwitchListTile(
          value: true,
          onChanged: (value) {},
          leadingIcon: Icons.mic_rounded,
          titleText: '音频降噪',
          subtitleText: '在嘈杂环境里，让对方更清晰地听到您的声音',
        ),
      ],
    );
  }
}
