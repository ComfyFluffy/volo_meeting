import 'package:volo_meeting/index.dart';

void main() => VoloMeeting.run();

class VoloMeetingApp extends ConsumerWidget {
  const VoloMeetingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateNotifierProvider);

    return MaterialApp(
      title: VoloMeeting.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: settings.username.isNullOrEmpty
          ? const UsernamePage()
          : const HomePage(),
    );
  }
}

class UsernamePage extends ConsumerStatefulWidget {
  const UsernamePage({
    super.key,
  });

  @override
  ConsumerState<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends ConsumerState<UsernamePage> {
  late final _controller = TextEditingController(
    text: ref.watch(settingsStateNotifierProvider).username,
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
                    .read(settingsStateNotifierProvider.notifier)
                    .setUsername(_controller.text);
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('用户名不能为空')),
                );
              }
            },
            child: Text(''),
          ),
        ],
      ),
    );
  }
}
