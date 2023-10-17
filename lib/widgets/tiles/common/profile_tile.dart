import 'package:volo_meeting/index.dart';

class ProfileTile extends ConsumerWidget {
  const ProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return BasedListTile(
      leading: const BasedAvatar(),
      titleText: settings.nickname,
      detail: const Badge(label: Text('免费版')),
      onTap: () => context.push(const ProfilePage()),
    );
  }
}
