import 'package:volo_meeting/index.dart';

class ProfileNameTile extends ConsumerWidget {
  const ProfileNameTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return BasedListTile(
      leadingIcon: Icons.draw_rounded,
      titleText: '用户名',
      detailText: settings.nickname,
      onTap: () => showDialog(
        context: context,
        builder: (context) => const _UsernameDialog(),
      ),
    );
  }
}

class _UsernameDialog extends ConsumerStatefulWidget {
  const _UsernameDialog();

  @override
  ConsumerState<_UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends ConsumerState<_UsernameDialog> {
  late final _controller = TextEditingController(
    text: ref.watch(settingsProvider).nickname,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('修改用户名'),
      content: TextField(autofocus: true, controller: _controller),
      actions: [
        TextButton(
          onPressed: () {
            if (_controller.text.isNotBlank) {
              ref.read(settingsProvider.notifier).setNickname(_controller.text);
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
