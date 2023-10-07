import 'package:volo_meeting/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const HomeAvatar(),
      ),
      drawer: const Drawer(),
      body: const BasedListSection(
        children: [
          TextField(),
        ],
      ),
    );
  }
}

class HomeAvatar extends StatelessWidget {
  const HomeAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BasedAvatar(
      onTap: () => context.push(const SettingsPage()),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              const BasedListTile(
                leadingIcon: Icons.draw_rounded,
                titleText: '用户名',
                detailText: 'User.name',
              ),
              BasedListTile(
                leadingIcon: Icons.devices_rounded,
                titleText: 'UUID',
                detailText: '$hashCode',
                onTap: () {
                  Clipboard.setData(ClipboardData(text: '$hashCode'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已复制')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
