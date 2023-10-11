import 'package:volo_meeting/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final _controller = TextEditingController(
    text: ref.watch(settingsProvider).username,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 360,
                child: BasedListSection(
                  titleText: '登录',
                  mainAxisSize: MainAxisSize.min,
                  itemPadding: const EdgeInsets.all(16),
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '请输入用户名',
                        border: OutlineInputBorder(),
                        labelText: '用户名',
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
                if (_controller.text.isNotBlank) {
                  context.pushAndRemoveRoot(const RootPage());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('用户名不能为空')),
                  );
                }
              },
              child: const Text('登录'),
            ),
          ),
        ],
      ),
    );
  }
}
