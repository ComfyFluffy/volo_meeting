import 'package:volo_meeting/index.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const _HomeAvatar(),
        title: Text(settings.username),
        centerTitle: false,
      ),
      drawer: const HomePageDrawer(),
      body: const HomePageBody(),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({
    super.key,
  });

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 360,
              child: BasedListSection(
                mainAxisSize: MainAxisSize.min,
                itemPadding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    autofocus: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '请输入会议号',
                      border: OutlineInputBorder(),
                      labelText: '会议号',
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
              if (_controller.text.isInt) {
                context.push(const MeetPage());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请检查会议号')),
                );
              }
            },
            child: const Text('加入会议'),
          ),
        ),
      ],
    );
  }
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar();

  @override
  Widget build(BuildContext context) {
    return BasedAvatar(
      onTap: Scaffold.of(context).openDrawer,
      badge: const Badge(
        backgroundColor: Colors.green,
      ),
    );
  }
}

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SafeArea(
        child: BasedListView(
          children: [
            ProfileTile(),
            BasedListSection(
              elevation: 0,
              children: [
                AccountSecureTile(),
                SettingsTile(),
                HelpServiceTile(),
                AboutUsTile(),
              ],
            ),
            BasedListSection(
              elevation: 0,
              children: [
                LogoutTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
