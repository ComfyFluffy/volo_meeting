import 'package:volo_meeting/index.dart';

class DeviceIdTile extends ConsumerWidget {
  const DeviceIdTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return BasedListTile(
      leadingIcon: Icons.devices_rounded,
      titleText: '设备ID',
      detailText: settings.deviceId,
      onTap: () {
        Clipboard.setData(ClipboardData(text: settings.deviceId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已复制')),
        );
      },
      onLongPress: ref.read(settingsProvider.notifier).randomDeviceId,
    );
  }
}
