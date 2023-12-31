import 'package:volo_meeting/index.dart';

class AudioEnableTile extends ConsumerWidget {
  const AudioEnableTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasedSwitchListTile(
      value: value,
      onChanged: onChanged,
      leadingIcon: Icons.mic_rounded,
      titleText: '入会开启麦克风',
    );
  }
}
