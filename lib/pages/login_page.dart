import 'package:volo_meeting/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  ConsumerState<LoginPage> createState() => _UsernamePageState();
}

class _UsernamePageState extends ConsumerState<LoginPage> {
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
                context.pushAndRemoveRoot(const RootPage());
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
