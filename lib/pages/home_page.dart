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
      ),
      drawer: const Drawer(),
    );
  }
}

class _HomeAvatar extends StatelessWidget {
  const _HomeAvatar();

  @override
  Widget build(BuildContext context) {
    return BasedAvatar(
      onTap: () => context.push(const SettingsPage()),
    );
  }
}
