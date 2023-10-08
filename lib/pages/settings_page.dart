import 'package:volo_meeting/index.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: BasedListView(
        children: [
          BasedListSection(
            titleText: '个人信息',
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: BasedAvatar(
                    size: 128,
                  ),
                ),
              ),
              BasedListTile(
                leadingIcon: Icons.draw_rounded,
                titleText: '用户名',
                detailText: settings.username,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => const UsernameDialog(),
                ),
              ),
              BasedListTile(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UsernameDialog extends ConsumerStatefulWidget {
  const UsernameDialog({
    super.key,
  });

  @override
  ConsumerState<UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends ConsumerState<UsernameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.watch(settingsProvider).username,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('修改用户名'),
      content: TextField(controller: _controller),
      actions: [
        TextButton(
          onPressed: () {
            if (_controller.text.isNotBlank) {
              ref.read(settingsProvider.notifier).setUsername(_controller.text);
              context.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('用户名不能为空')),
              );
            }
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}
