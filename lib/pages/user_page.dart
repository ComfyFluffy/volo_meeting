import 'package:volo_meeting/index.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({
    super.key,
  });

  @override
  ConsumerState<UserPage> createState() => _UsernamePageState();
}

class _UsernamePageState extends ConsumerState<UserPage> {
  late final _controller = TextEditingController(
    text: ref.watch(settingsProvider).username,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户名'),
      ),
      body: BasedListView(
        children: [
          BasedListSection(
            titleText: '请设置用户名',
            children: [
              Center(
                child: TextField(
                  controller: _controller,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotBlank) {
                ref
                    .read(settingsProvider.notifier)
                    .setUsername(_controller.text);
                context.pushAndRemoveRoot(const HomePage());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('用户名不能为空')),
                );
              }
            },
            child: const Text(''),
          ),
        ],
      ),
    );
  }
}
